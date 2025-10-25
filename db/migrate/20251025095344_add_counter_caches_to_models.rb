class AddCounterCachesToModels < ActiveRecord::Migration[8.0]
  def up
    # Add counter cache columns
    add_column :users, :notes_count, :integer, default: 0, null: false
    add_column :users, :todos_count, :integer, default: 0, null: false
    add_column :folders, :notes_count, :integer, default: 0, null: false
    add_column :tags, :notes_count, :integer, default: 0, null: false

    # Backfill existing counts
    User.find_each do |user|
      User.reset_counters(user.id, :notes, :todos)
    end

    Folder.find_each do |folder|
      Folder.reset_counters(folder.id, :notes)
    end

    Tag.find_each do |tag|
      # For tags, we need to manually count since it's through a join table
      Tag.update_counters(tag.id, notes_count: tag.notes.count)
    end
  end

  def down
    remove_column :users, :notes_count
    remove_column :users, :todos_count
    remove_column :folders, :notes_count
    remove_column :tags, :notes_count
  end
end
