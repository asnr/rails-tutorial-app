require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @nonactivated_user = users(:jess)
  end

  test "should redirect on show for nonactivated user" do
    assert_not @nonactivated_user.activated?
    get user_path(@nonactivated_user)
    assert_redirected_to root_path
  end
end
