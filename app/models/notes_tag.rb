class NotesTag < ApplicationRecord
  belongs_to :note
  belongs_to :tag
  belongs_to :user

  validates :note_id, uniqueness: { scope: :tag_id }
end
