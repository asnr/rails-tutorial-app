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

  test 'should ignore admin key in params when updating a user' do
    log_in_as @other_user
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { admin: true,
                                            password: 'password',
                                            password_confirmation: 'password' } }
    assert_redirected_to user_path(@other_user)
    assert_not @other_user.reload.admin?
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


  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_path
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user.id)
    end
    assert_redirected_to login_path
  end

  test 'should redirect destroy when logged in as non-admin' do
    log_in_as @other_user
    assert_no_difference 'User.count' do
      delete user_path(@user.id)
    end
    assert_redirected_to root_path
  end

  test 'should redirect following when not logged in' do
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  test 'should redirect followers when not logged in' do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end
end
