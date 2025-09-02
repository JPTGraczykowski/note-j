class CreateTodosTags < ActiveRecord::Migration[8.0]
  def change
    create_table :todos_tags do |t|
      t.references :todo, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :todos_tags, [:todo_id, :tag_id], unique: true
    add_index :todos_tags, [:tag_id, :todo_id]
  end
end
