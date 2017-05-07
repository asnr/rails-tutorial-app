require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:fred)
    @micropost = @user.microposts.build content: 'Some content'
  end

  test 'content should be present' do
    @micropost.content = '     '
    assert_not @micropost.valid?
  end

  test "should be shorter than 140 characters" do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test 'should have an user id' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'correct post is valid' do
    assert @micropost.valid?
  end

  test 'order should be most recent first' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
