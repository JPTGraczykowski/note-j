require 'rails_helper'

RSpec.describe Tag, type: :model do
  context "validations" do
    it "is valid with name and user" do
      tag = build(:tag)

      expect(tag).to be_valid
    end

    it "requires name" do
      tag = build(:tag, name: nil)

      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("can't be blank")
    end

    it "requires user" do
      tag = build(:tag, user: nil)

      expect(tag).not_to be_valid
      expect(tag.errors[:user]).to include("must exist")
    end

    it "requires unique name within user scope" do
      user = create(:user)
      existing_tag = create(:tag, name: "important", user: user)
      duplicate_tag = build(:tag, name: "important", user: user)

      expect(duplicate_tag).not_to be_valid
      expect(duplicate_tag.errors[:name]).to include("has already been taken")
    end
  end

  context "associations" do
    it "belongs to user" do
      expect(Tag.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "has many notes" do
      expect(Tag.reflect_on_association(:notes).macro).to eq(:has_many)
      expect(Tag.reflect_on_association(:notes).through_reflection.name).to eq(:notes_tags)
    end

    it "has many todos" do
      expect(Tag.reflect_on_association(:todos).macro).to eq(:has_many)
      expect(Tag.reflect_on_association(:todos).through_reflection.name).to eq(:todos_tags)
    end
  end

  context "scopes" do
    it "finds tags for specific user" do
      user1 = create(:user)
      user2 = create(:user)
      tag1 = create(:tag, user: user1)
      tag2 = create(:tag, user: user2)

      user1_tags = Tag.for_user(user1)
      expect(user1_tags).to include(tag1)
      expect(user1_tags).not_to include(tag2)
    end
  end

  context "methods" do
    it "returns name as string representation" do
      tag = build(:tag, name: "important")

      expect(tag.to_s).to eq("important")
    end

    it "finds next popular tag" do
      user = create(:user)
      tag1 = create(:tag, name: "important", user: user)
      tag2 = create(:tag, name: "urgent", user: user)
      tag3 = create(:tag, name: "work", user: user)
      tag4 = create(:tag, name: "personal", user: user)
      note11 = create(:note, user: user)
      NotesTag.create(note: note11, tag: tag1, user: user)
      note21 = create(:note, user: user)
      note22 = create(:note, user: user)
      NotesTag.create(note: note21, tag: tag2, user: user)
      NotesTag.create(note: note22, tag: tag2, user: user)
      note31 = create(:note, user: user)
      note32 = create(:note, user: user)
      note33 = create(:note, user: user)
      NotesTag.create(note: note31, tag: tag3, user: user)
      NotesTag.create(note: note32, tag: tag3, user: user)
      NotesTag.create(note: note33, tag: tag3, user: user)
      note41 = create(:note, user: user)
      note42 = create(:note, user: user)
      note43 = create(:note, user: user)
      note44 = create(:note, user: user)
      NotesTag.create(note: note41, tag: tag4, user: user)
      NotesTag.create(note: note42, tag: tag4, user: user)
      NotesTag.create(note: note43, tag: tag4, user: user)
      NotesTag.create(note: note44, tag: tag4, user: user)

      expect(tag4.find_next_popular).to eq(tag3)
      expect(tag3.find_next_popular).to eq(tag2)
      expect(tag2.find_next_popular).to eq(tag1)
    end
  end

  context "counter cache" do
    it "increments notes_count when note is tagged" do
      user = create(:user)
      tag = create(:tag, user: user)
      expect(tag.notes_count).to eq(0)

      note1 = create(:note, user: user)
      NotesTag.create(note: note1, tag: tag, user: user)
      tag.reload
      expect(tag.notes_count).to eq(1)

      note2 = create(:note, user: user)
      NotesTag.create(note: note2, tag: tag, user: user)
      tag.reload
      expect(tag.notes_count).to eq(2)
    end

    it "decrements notes_count when note is untagged" do
      user = create(:user)
      tag = create(:tag, user: user)
      note1 = create(:note, user: user)
      note2 = create(:note, user: user)
      notes_tag1 = NotesTag.create(note: note1, tag: tag, user: user)
      notes_tag2 = NotesTag.create(note: note2, tag: tag, user: user)
      tag.reload
      expect(tag.notes_count).to eq(2)

      notes_tag1.destroy
      tag.reload
      expect(tag.notes_count).to eq(1)

      notes_tag2.destroy
      tag.reload
      expect(tag.notes_count).to eq(0)
    end

    it "maintains correct notes_count across multiple operations" do
      user = create(:user)
      tag = create(:tag, user: user)
      note1 = create(:note, user: user)
      note2 = create(:note, user: user)
      note3 = create(:note, user: user)

      notes_tag1 = NotesTag.create(note: note1, tag: tag, user: user)
      notes_tag2 = NotesTag.create(note: note2, tag: tag, user: user)
      notes_tag3 = NotesTag.create(note: note3, tag: tag, user: user)
      tag.reload
      expect(tag.notes_count).to eq(3)

      notes_tag2.destroy
      tag.reload
      expect(tag.notes_count).to eq(2)

      note4 = create(:note, user: user)
      NotesTag.create(note: note4, tag: tag, user: user)
      tag.reload
      expect(tag.notes_count).to eq(3)
    end
  end
end
