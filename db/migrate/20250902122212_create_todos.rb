class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.text :description, null: false
      t.boolean :completed, default: false, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :todos, [:user_id, :completed]
    add_index :todos, [:user_id, :created_at]
  end
end
