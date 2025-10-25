class DropTodosTags < ActiveRecord::Migration[8.0]
  def change
    drop_table :todos_tags do |t|
      t.references :todo, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
