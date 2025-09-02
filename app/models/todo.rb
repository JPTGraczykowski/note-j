class Todo < ApplicationRecord
  belongs_to :user

  has_many :todos_tags
  has_many :tags, through: :todos_tags

  validates :description, presence: true, length: { maximum: 1000 }

  scope :for_user, ->(user) { where(user: user) }
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :tagged_with, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }

  def toggle_completion!
    update!(completed: !completed)
  end

  def mark_completed!
    update!(completed: true)
  end

  def mark_pending!
    update!(completed: false)
  end

  def status
    completed? ? "completed" : "pending"
  end

  def completed?
    completed
  end

  def pending?
    !completed
  end

  def tag_names
    tags.pluck(:name)
  end
end
