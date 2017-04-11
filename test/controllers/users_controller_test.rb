require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fred)
    @other_user = users(:amy)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end


  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@user)
    get edit_user_path(@other_user)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: 'new name',
                                              email: 'new@email.com',
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect update when loggend in as wrong user' do
    log_in_as(@user)
    patch user_path(@other_user), params: { user: { name: 'new name',
                                                    email: 'new@email.com' } }
    assert flash.empty?
    assert_redirected_to root_path
  end
end
