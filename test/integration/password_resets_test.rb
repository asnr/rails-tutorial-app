require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fred)
    ActionMailer::Base.deliveries.clear
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_path
    assert_not flash.empty?

    # Password reset form
    user = assigns(:user)

    # Invalid password reset token
    get edit_password_reset_path('invalid token', email: @user.email)
    assert_redirected_to root_path

    # Invalid email
    get edit_password_reset_path(user.reset_token, email: 'invalid email')
    assert_redirected_to root_path

    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_path
    user.toggle!(:activated)

    # Correct email and reset token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    new_password = 'password1'
    patch password_reset_path(user.reset_token,
                              email: @user.email,
                              user: {
                                password: new_password,
                                password_confirmation: new_password
                              })
    assert_redirected_to @user
    assert is_logged_in?
    assert_not flash.empty?
    @user.reload
    assert @user.authenticated?(:password, new_password)
    assert_nil @user.reset_digest
    assert_nil @user.reset_sent_at
  end

  test 'expired password resets' do
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    user = assigns(:user)

    new_password = 'foobar'
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: new_password,
                            password_confirmation: new_password } }
    assert_not flash.empty?
    assert_not is_logged_in?
    assert_not @user.reload.authenticated?(:password, new_password)
    assert_redirected_to new_password_reset_path
  end
end
