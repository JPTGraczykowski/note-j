class Tag < ApplicationRecord
  belongs_to :user
  has_many :notes_tags
  has_many :notes, through: :notes_tags

  validates :name, presence: true, uniqueness: { scope: :user_id }

  scope :for_user, ->(user) { where(user: user) }

  def to_s
    name
  end
end
