class AddTodoListToTodos < ActiveRecord::Migration[8.0]
  def change
    add_reference :todos, :todo_list, null: false, foreign_key: true
    add_index :todos, [:todo_list_id, :completed]
  end
end
