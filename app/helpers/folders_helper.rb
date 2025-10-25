module FoldersHelper
  def root_folders(all_folders)
    all_folders.select { |f| f.parent_id.nil? }
  end

  def children_for_folder(folder, all_folders)
    all_folders.select { |f| f.parent_id == folder.id }
  end
end
