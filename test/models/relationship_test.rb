require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @user = users(:fred)
    @other_user = users(:amy)
    @relationship = Relationship.new follower: @user, followed: @other_user
  end

  test "relationship without follower is invalid" do
    @relationship.follower = nil
    assert_not @relationship.valid?
  end

  test 'relationship without followed is invalid' do
    @relationship.followed = nil
    assert_not @relationship.valid?
  end

  test 'follower and followed cannot be the same' do
    @relationship.followed = @relationship.follower
    assert_not @relationship.valid?
  end

  # test 'relationship must be be unique' do
    # duplicate = @relationship.dup
    # @relationship.save
    # assert_not duplicate.save
  # end
end
