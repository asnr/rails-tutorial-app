require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fred)
  end

  test "the truth" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select "h1 img:match('src', ?)", %r{secure.gravatar.com/avatar}
    assert_select "h1", text: @user.name
    # assert_select "h3", text: @user.microposts.count.to_s what's the syntax?
    assert_select 'ol.microposts li', count: 30
    assert_select 'div.pagination', count: 1
  end
end
