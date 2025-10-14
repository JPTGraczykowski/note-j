class Tag < ApplicationRecord
  belongs_to :user
  has_many :notes_tags, dependent: :destroy
  has_many :notes, through: :notes_tags
  has_many :todos_tags, dependent: :destroy
  has_many :todos, through: :todos_tags

  validates :name, presence: true, uniqueness: { scope: :user_id }

  scope :for_user, ->(user) { where(user: user) }
  scope :popular, -> { left_joins(:notes).group("tags.id").order("COUNT(notes.id) DESC") }

  def to_s
    name
  end

  def find_next_popular
    user
      .tags
      .left_joins(:notes)
      .group("tags.id")
      .where("tags.id != ?", id)
      .having("COUNT(notes.id) < ?", notes.count)
      .order("COUNT(notes.id) DESC")
      .first
  end
end
