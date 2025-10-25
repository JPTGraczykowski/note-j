class AddTodoListsCountToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :todo_lists_count, :integer, default: 0, null: false
  end
end
