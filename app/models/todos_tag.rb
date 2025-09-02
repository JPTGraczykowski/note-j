class TodosTag < ApplicationRecord
  belongs_to :todo
  belongs_to :tag
  belongs_to :user

  validates :todo_id, uniqueness: { scope: :tag_id }
end
