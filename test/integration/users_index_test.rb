require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:fred)
    @nonadmin = users(:amy)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href = ?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href = ?]', user_path(user), text: 'Delete'
      end
    end

    assert_difference 'User.count', -1 do
      delete user_path(@nonadmin)
    end
  end

  test 'index as nonadmin does not show delete links' do
    log_in_as @nonadmin
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end
end
