class Tag < ApplicationRecord
  belongs_to :user
  has_many :notes_tags, dependent: :destroy
  has_many :notes, through: :notes_tags
  has_many :todos_tags, dependent: :destroy
  has_many :todos, through: :todos_tags

  validates :name, presence: true, uniqueness: { scope: :user_id }

  scope :for_user, ->(user) { where(user: user) }
  scope :popular, -> { joins(:notes).group(:name).order("COUNT(notes.id) DESC") }

  def to_s
    name
  end
end
