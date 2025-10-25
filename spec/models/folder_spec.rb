require 'rails_helper'

RSpec.describe Folder, type: :model do
  context "validations" do
    it "is valid with name and user" do
      folder = build(:folder)

      expect(folder).to be_valid
    end

    it "requires name" do
      folder = build(:folder, name: nil)

      expect(folder).not_to be_valid
      expect(folder.errors[:name]).to include("can't be blank")
    end

    it "requires user" do
      folder = build(:folder, user: nil)

      expect(folder).not_to be_valid
      expect(folder.errors[:user]).to include("must exist")
    end

    it "requires unique name within user and parent folder scope" do
      user = create(:user)
      parent_folder = create(:folder, name: "Parent", user: user)
      existing_folder = create(:folder, name: "Documents", user: user, parent: parent_folder)
      duplicate_folder = build(:folder, name: "Documents", user: user, parent: parent_folder)

      expect(duplicate_folder).not_to be_valid
      expect(duplicate_folder.errors[:name]).to include("has already been taken")
    end

    it "cannot be parent of itself" do
      folder = create(:folder)
      folder.parent_id = folder.id

      expect(folder).not_to be_valid
      expect(folder.errors[:parent_id]).to include("cannot be the same as the folder itself")
    end

    it "prevents circular references" do
      user = create(:user)
      parent = create(:folder, name: "Parent", user: user)
      child = create(:folder, name: "Child", user: user, parent: parent)
      parent.parent_id = child.id

      expect(parent).not_to be_valid
      expect(parent.errors[:parent_id]).to include("cannot create circular reference")
    end
  end

  context "associations" do
    it "belongs to user" do
      expect(Folder.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "belongs to parent folder (optional)" do
      expect(Folder.reflect_on_association(:parent).macro).to eq(:belongs_to)
      expect(Folder.reflect_on_association(:parent).options[:optional]).to be true
    end

    it "has many children folders" do
      expect(Folder.reflect_on_association(:children).macro).to eq(:has_many)
      expect(Folder.reflect_on_association(:children).options[:dependent]).to eq(:destroy)
    end
  end

  context "scopes" do
    it "finds root folders" do
      user = create(:user)
      root1 = create(:folder, name: "Root1", user: user)
      root2 = create(:folder, name: "Root2", user: user)
      child = create(:folder, name: "Child", parent: root1, user: user)

      root_folders = Folder.root_folders
      expect(root_folders).to include(root1, root2)
      expect(root_folders).not_to include(child)
    end

    it "finds folders for specific user" do
      user1 = create(:user)
      user2 = create(:user)
      folder1 = create(:folder, user: user1)
      folder2 = create(:folder, user: user2)

      user1_folders = Folder.for_user(user1)
      expect(user1_folders).to include(folder1)
      expect(user1_folders).not_to include(folder2)
    end
  end

  context "methods" do
    it "identifies root folders" do
      root_folder = create(:folder)
      child_folder = create(:folder, parent: root_folder, user: root_folder.user)

      expect(root_folder.root?).to be true
      expect(child_folder.root?).to be false
    end

    it "checks if folder has children" do
      parent = create(:folder)
      child = create(:folder, parent: parent, user: parent.user)
      empty_folder = create(:folder, user: parent.user)

      expect(parent.has_children?).to be true
      expect(empty_folder.has_children?).to be false
    end

    it "returns ancestors" do
      user = create(:user)
      grandparent = create(:folder, name: "Grandparent", user: user)
      parent = create(:folder, name: "Parent", parent: grandparent, user: user)
      child = create(:folder, name: "Child", parent: parent, user: user)

      expect(child.ancestors).to eq([parent, grandparent])
      expect(parent.ancestors).to eq([grandparent])
      expect(grandparent.ancestors).to eq([])
    end

    it "returns descendants" do
      user = create(:user)
      parent = create(:folder, name: "Parent", user: user)
      child1 = create(:folder, name: "Child1", parent: parent, user: user)
      child2 = create(:folder, name: "Child2", parent: parent, user: user)
      grandchild = create(:folder, name: "Grandchild", parent: child1, user: user)

      descendants = parent.descendants
      expect(descendants).to include(child1, child2, grandchild)
      expect(descendants.size).to eq(3)
    end

    it "returns full path" do
      user = create(:user)
      parent = create(:folder, name: "Documents", user: user)
      child = create(:folder, name: "Work", parent: parent, user: user)
      grandchild = create(:folder, name: "Projects", parent: child, user: user)

      expect(parent.full_path).to eq("Documents")
      expect(child.full_path).to eq("Documents/Work")
      expect(grandchild.full_path).to eq("Documents/Work/Projects")
    end

    it "calculates depth correctly" do
      user = create(:user)
      root = create(:folder, name: "Root", user: user)
      level1 = create(:folder, name: "Level1", parent: root, user: user)
      level2 = create(:folder, name: "Level2", parent: level1, user: user)

      expect(root.depth).to eq(0)
      expect(level1.depth).to eq(1)
      expect(level2.depth).to eq(2)
    end

    it "finds next sibling folder" do
      user = create(:user)
      parent_folder_a = create(:folder, name: "Parent Folder A", user: user)
      folder_a = create(:folder, name: "Folder A", user: user, parent: parent_folder_a)
      folder_b = create(:folder, name: "Folder B", user: user, parent: parent_folder_a)
      folder_c = create(:folder, name: "Folder C", user: user, parent: parent_folder_a)
      parent_folder_b = create(:folder, name: "Parent Folder B", user: user)

      expect(folder_a.find_next_sibling).to eq(folder_b)
      expect(folder_b.find_next_sibling).to eq(folder_c)
      expect(parent_folder_a.find_next_sibling).to eq(parent_folder_b)
    end

    it "finds next sibling folder in root folders" do
      user = create(:user)
      folder1 = create(:folder, name: "Folder1", user: user)
      folder2 = create(:folder, name: "Folder2", user: user)
      folder3 = create(:folder, name: "Folder3", user: user)

      expect(folder1.find_next_sibling).to eq(folder2)
      expect(folder2.find_next_sibling).to eq(folder3)
    end
  end

  context "counter cache" do
    it "increments notes_count when note is added to folder" do
      folder = create(:folder)
      expect(folder.notes_count).to eq(0)

      create(:note, folder: folder, user: folder.user)
      folder.reload
      expect(folder.notes_count).to eq(1)

      create(:note, folder: folder, user: folder.user)
      folder.reload
      expect(folder.notes_count).to eq(2)
    end

    it "decrements notes_count when note is removed from folder" do
      folder = create(:folder)
      note1 = create(:note, folder: folder, user: folder.user)
      note2 = create(:note, folder: folder, user: folder.user)
      folder.reload
      expect(folder.notes_count).to eq(2)

      note1.destroy
      folder.reload
      expect(folder.notes_count).to eq(1)

      note2.destroy
      folder.reload
      expect(folder.notes_count).to eq(0)
    end

    it "updates notes_count when note is moved between folders" do
      user = create(:user)
      folder1 = create(:folder, name: "Folder 1", user: user)
      folder2 = create(:folder, name: "Folder 2", user: user)
      note = create(:note, folder: folder1, user: user)

      folder1.reload
      folder2.reload
      expect(folder1.notes_count).to eq(1)
      expect(folder2.notes_count).to eq(0)

      note.update(folder: folder2)
      folder1.reload
      folder2.reload
      expect(folder1.notes_count).to eq(0)
      expect(folder2.notes_count).to eq(1)
    end

    it "increments children_count when child folder is added" do
      user = create(:user)
      parent = create(:folder, name: "Parent", user: user)
      expect(parent.children_count).to eq(0)

      create(:folder, name: "Child 1", parent: parent, user: user)
      parent.reload
      expect(parent.children_count).to eq(1)

      create(:folder, name: "Child 2", parent: parent, user: user)
      parent.reload
      expect(parent.children_count).to eq(2)
    end

    it "decrements children_count when child folder is removed" do
      user = create(:user)
      parent = create(:folder, name: "Parent", user: user)
      child1 = create(:folder, name: "Child 1", parent: parent, user: user)
      child2 = create(:folder, name: "Child 2", parent: parent, user: user)
      parent.reload
      expect(parent.children_count).to eq(2)

      child1.destroy
      parent.reload
      expect(parent.children_count).to eq(1)

      child2.destroy
      parent.reload
      expect(parent.children_count).to eq(0)
    end

    it "updates children_count when child folder is moved between parents" do
      user = create(:user)
      parent1 = create(:folder, name: "Parent 1", user: user)
      parent2 = create(:folder, name: "Parent 2", user: user)
      child = create(:folder, name: "Child", parent: parent1, user: user)

      parent1.reload
      parent2.reload
      expect(parent1.children_count).to eq(1)
      expect(parent2.children_count).to eq(0)

      child.update(parent: parent2)
      parent1.reload
      parent2.reload
      expect(parent1.children_count).to eq(0)
      expect(parent2.children_count).to eq(1)
    end

    it "has_children? uses children_count cache" do
      user = create(:user)
      parent = create(:folder, name: "Parent", user: user)
      expect(parent.has_children?).to be false

      create(:folder, name: "Child", parent: parent, user: user)
      parent.reload
      expect(parent.has_children?).to be true
    end
  end
end
