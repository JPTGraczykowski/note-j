class NotesTag < ApplicationRecord
  belongs_to :note
  belongs_to :tag
  belongs_to :user

  validates :note_id, uniqueness: { scope: :tag_id }

  before_validation :assign_user
  after_create :increment_tag_notes_count
  after_destroy :decrement_tag_notes_count

  private

  def assign_user
    self.user_id ||= tag&.user_id
  end

  def increment_tag_notes_count
    tag&.increment!(:notes_count)
  end

  def decrement_tag_notes_count
    tag&.decrement!(:notes_count)
  end
end
