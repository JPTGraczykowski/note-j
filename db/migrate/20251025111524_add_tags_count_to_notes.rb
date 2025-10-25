class AddTagsCountToNotes < ActiveRecord::Migration[8.0]
  def up
    add_column :notes, :tags_count, :integer, default: 0, null: false

    Note.find_each do |note|
      Note.update_counters(note.id, tags_count: note.tags.count)
    end
  end

  def down
    remove_column :notes, :tags_count
  end
end
