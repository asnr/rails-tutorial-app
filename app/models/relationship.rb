class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validate :followed_different_from_follower

  private
    def followed_different_from_follower
      if follower == followed
        errors.add(:followed, 'cannot be the same as follower')
      end
    end
end
