require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:fred)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    patch user_path(@user), params: { user: { name: "",
                                              email: 'fred@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div#error_explanation > ul > li', count: 4
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    new_name = 'Sally User'
    new_email = 'sally@user.com'
    patch user_path(@user),
         params: { user: { name: new_name,
                           email: new_email,
                           password: '',
                           password_confirmation: '' } }
    assert !flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end
end
