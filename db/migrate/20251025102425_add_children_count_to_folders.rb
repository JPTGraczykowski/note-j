class AddChildrenCountToFolders < ActiveRecord::Migration[8.0]
  def up
    add_column :folders, :children_count, :integer, default: 0, null: false

    # Backfill existing counts
    Folder.find_each do |folder|
      Folder.reset_counters(folder.id, :children)
    end
  end

  def down
    remove_column :folders, :children_count
  end
end
