class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :content
      t.references :folder, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :notes, [:user_id, :title]
    add_index :notes, [:user_id, :folder_id]
    add_index :notes, [:user_id, :created_at]
    add_index :notes, :title
  end
end
