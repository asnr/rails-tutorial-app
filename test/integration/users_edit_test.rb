require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:fred)
  end

  test "unsuccessful edit" do
    patch user_path(@user), params: { user: { name: "",
                                              email: 'fred@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div#error_explanation > ul > li', count: 4
  end

  test 'successful edit' do
    skip('Need to finish writing test (RED) and then need to implement it (GREEN)')
    new_name = 'Sally User'
    patch user_path(@user),
         params: { user: { name: new_name,
                           email: @user.email,
                           password: 'password',
                           password_confirmation: 'password' } }
    assert_template 'users/show'
    assert_select 'div.alert-success', count: 1
    assert_select 'h1', new_name
  end
end
