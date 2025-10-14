class NotesTag < ApplicationRecord
  belongs_to :note
  belongs_to :tag
  belongs_to :user

  validates :note_id, uniqueness: { scope: :tag_id }

  before_validation :assign_user

  private

  def assign_user
    self.user_id ||= tag.user_id
  end
end
