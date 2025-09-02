require 'rails_helper'

RSpec.describe NotesTag, type: :model do
  context "associations" do
    it "belongs to note" do
      expect(NotesTag.reflect_on_association(:note).macro).to eq(:belongs_to)
    end

    it "belongs to tag" do
      expect(NotesTag.reflect_on_association(:tag).macro).to eq(:belongs_to)
    end

    it "belongs to user" do
      expect(NotesTag.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end

  context "validations" do
    it "is valid with note, tag and user" do
      notes_tag = build(:notes_tag)

      expect(notes_tag).to be_valid
    end

    it "requires note" do
      notes_tag = build(:notes_tag, note: nil)

      expect(notes_tag).not_to be_valid
      expect(notes_tag.errors[:note]).to include("must exist")
    end

    it "requires tag" do
      notes_tag = build(:notes_tag, tag: nil)

      expect(notes_tag).not_to be_valid
      expect(notes_tag.errors[:tag]).to include("must exist")
    end

    it "requires user" do
      notes_tag = build(:notes_tag, user: nil)

      expect(notes_tag).not_to be_valid
      expect(notes_tag.errors[:user]).to include("must exist")
    end

    it "is invalid with duplicate note and tag" do
      notes_tag = create(:notes_tag)
      duplicate_notes_tag = build(:notes_tag, note: notes_tag.note, tag: notes_tag.tag)

      expect(duplicate_notes_tag).not_to be_valid
      expect(duplicate_notes_tag.errors[:note_id]).to include("has already been taken")
    end
  end
end
