class CreateNoteTagsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :notes_tags do |t|
      t.references :note, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :notes_tags, [:note_id, :tag_id], unique: true
    add_index :notes_tags, [:tag_id, :note_id]
  end
end
