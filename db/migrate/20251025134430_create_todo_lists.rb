class CreateTodoLists < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_lists do |t|
      t.string :title, null: false
      t.boolean :completed, default: false, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :todo_lists, [:user_id, :completed]
    add_index :todo_lists, [:user_id, :created_at]
  end
end
