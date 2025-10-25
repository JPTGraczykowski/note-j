class TodoList < ApplicationRecord
  belongs_to :user, counter_cache: true

  has_many :todos, dependent: :destroy

  validates :title, presence: true, length: { maximum: 500 }

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

  def progress_percentage
    return 0 if todos.none?
    (todos.completed.count.to_f / todos.count * 100).round
  end

  def all_todos_completed?
    todos.any? && todos.all?(&:completed?)
  end

  def pending_todos_count
    todos.pending.count
  end

  def completed_todos_count
    todos.completed.count
  end
end
