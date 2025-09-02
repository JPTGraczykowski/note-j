require 'rails_helper'

RSpec.describe Note, type: :model do
  context "validations" do
    it "is valid with title and user" do
      note = build(:note)

      expect(note).to be_valid
    end

    it "requires title" do
      note = build(:note, title: nil)

      expect(note).not_to be_valid
      expect(note.errors[:title]).to include("can't be blank")
    end

    it "requires user" do
      note = build(:note, user: nil)

      expect(note).not_to be_valid
      expect(note.errors[:user]).to include("must exist")
    end

    it "validates title length" do
      note = build(:note, title: "a" * 201)

      expect(note).not_to be_valid
      expect(note.errors[:title]).to include("is too long (maximum is 200 characters)")
    end

    it "allows empty content" do
      note = build(:note, content: nil)

      expect(note).to be_valid
    end

    it "allows note without folder" do
      note = build(:note, folder: nil)

      expect(note).to be_valid
    end
  end

  context "associations" do
    it "belongs to user" do
      expect(Note.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "belongs to folder (optional)" do
      expect(Note.reflect_on_association(:folder).macro).to eq(:belongs_to)
      expect(Note.reflect_on_association(:folder).options[:optional]).to be true
    end

    it "has many attached images" do
      note = create(:note)

      expect(note.images).to be_instance_of(ActiveStorage::Attached::Many)
    end
  end

  context "scopes" do
    it "finds notes for specific user" do
      user1 = create(:user)
      user2 = create(:user)
      note1 = create(:note, user: user1)
      note2 = create(:note, user: user2)

      user1_notes = Note.for_user(user1)
      expect(user1_notes).to include(note1)
      expect(user1_notes).not_to include(note2)
    end

    it "finds notes in specific folder" do
      folder = create(:folder)
      note_in_folder = create(:note, folder: folder, user: folder.user)
      note_without_folder = create(:note, folder: nil, user: folder.user)

      folder_notes = Note.in_folder(folder)
      expect(folder_notes).to include(note_in_folder)
      expect(folder_notes).not_to include(note_without_folder)
    end

    it "finds notes without folder" do
      user = create(:user)
      folder = create(:folder, user: user)
      note_in_folder = create(:note, folder: folder, user: user)
      note_without_folder = create(:note, folder: nil, user: user)

      unfiled_notes = Note.without_folder
      expect(unfiled_notes).to include(note_without_folder)
      expect(unfiled_notes).not_to include(note_in_folder)
    end

    it "orders notes by most recent" do
      user = create(:user)
      old_note = create(:note, user: user, created_at: 2.days.ago)
      new_note = create(:note, user: user, created_at: 1.day.ago)

      recent_notes = Note.recent
      expect(recent_notes.first).to eq(new_note)
      expect(recent_notes.last).to eq(old_note)
    end

    it "searches notes by title" do
      user = create(:user)
      matching_note = create(:note, title: "Important Meeting", user: user)
      non_matching_note = create(:note, title: "Grocery List", user: user)

      search_results = Note.search_by_title("Meeting")
      expect(search_results).to include(matching_note)
      expect(search_results).not_to include(non_matching_note)
    end
  end

  context "methods" do
    it "returns folder name" do
      folder = create(:folder, name: "Work")
      note = create(:note, folder: folder, user: folder.user)

      expect(note.folder_name).to eq("Work")
    end

    it "returns 'No folder' when no folder" do
      note = create(:note, folder: nil)

      expect(note.folder_name).to eq("No folder")
    end

    it "returns folder path" do
      user = create(:user)
      parent_folder = create(:folder, name: "Projects", user: user)
      child_folder = create(:folder, name: "Work", parent: parent_folder, user: user)
      note = create(:note, folder: child_folder, user: user)

      expect(note.folder_path).to eq("Projects/Work")
    end

    it "returns 'No folder' path when no folder" do
      note = create(:note, folder: nil)

      expect(note.folder_path).to eq("No folder")
    end

    it "checks if note has images" do
      note = create(:note)

      expect(note.has_images?).to be false
    end
  end

  context "image upload" do
    it "includes ImageUploadable concern" do
      expect(Note.included_modules).to include(ImageUploadable)
    end
  end
end
