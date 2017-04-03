require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

  test 'valid signup information' do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'A person',
                                          email: 'a@person.com',
                                          password: 'password',
                                          confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.empty?
  end
end
