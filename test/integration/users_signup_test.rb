require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '', email: 'user@invalid',
                                          password: 'foo',
                                          confirmation: 'bar'} }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation div.alert', /.+3 errors.+/
    assert_select 'div#error_explanation ul > li', 3
  end

  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'A person',
                                          email: 'a@person.com',
                                          password: 'password',
                                          confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as user
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path('Invalid token', email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'not email')
    assert_not is_logged_in?
    # Valid token and email
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
