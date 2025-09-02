class Todo < ApplicationRecord
  belongs_to :user

  validates :description, presence: true, length: { maximum: 1000 }

  scope :for_user, ->(user) { where(user: user) }
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }

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
end
