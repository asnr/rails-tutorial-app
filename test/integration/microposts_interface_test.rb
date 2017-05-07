require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:fred)
    @other_user = users(:amy)
  end

  test "should view and create microposts and delete only user's own" do
    log_in_as @user
    get root_path
    assert_select 'div.pagination', count: 1
    assert_select 'input[type=file]', count: 1
    assert_select 'a', text: 'delete'

    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation', count: 1

    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: {
                                        content: 'Some content',
                                        picture: picture
                                      } }
    end
    new_micropost = assigns(:micropost)
    assert new_micropost.picture?
    assert_not flash.empty?
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'ol.microposts>li:first-child', text: /.*Some content.*/

    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@user.microposts.first)
    end

    get user_path(@other_user)
    assert_select 'a', text: 'delete', count: 0
  end

  test "should display micropost sidebar count" do
    log_in_as @user
    get root_path
    assert_select 'section.user_info',
                  text: /.*#{@user.microposts.count.to_s}.*/
  end
end
