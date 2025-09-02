require 'rails_helper'

RSpec.describe TodosTag, type: :model do
  context "associations" do
    it "belongs to todo" do
      expect(TodosTag.reflect_on_association(:todo).macro).to eq(:belongs_to)
    end

    it "belongs to tag" do
      expect(TodosTag.reflect_on_association(:tag).macro).to eq(:belongs_to)
    end

    it "belongs to user" do
      expect(TodosTag.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end

  context "validations" do
    it "is valid with todo, tag, and user" do
      user = create(:user)
      todo = create(:todo, user: user)
      tag = create(:tag, user: user)
      todos_tag = build(:todos_tag, todo: todo, tag: tag, user: user)

      expect(todos_tag).to be_valid
    end

    it "requires todo" do
      todos_tag = build(:todos_tag, todo: nil)

      expect(todos_tag).not_to be_valid
      expect(todos_tag.errors[:todo]).to include("must exist")
    end

    it "requires tag" do
      todos_tag = build(:todos_tag, tag: nil)

      expect(todos_tag).not_to be_valid
      expect(todos_tag.errors[:tag]).to include("must exist")
    end

    it "requires user" do
      todos_tag = build(:todos_tag, user: nil)

      expect(todos_tag).not_to be_valid
      expect(todos_tag.errors[:user]).to include("must exist")
    end

    it "prevents duplicate todo-tag combinations" do
      user = create(:user)
      todo = create(:todo, user: user)
      tag = create(:tag, user: user)
      existing_todos_tag = create(:todos_tag, todo: todo, tag: tag, user: user)
      duplicate_todos_tag = build(:todos_tag, todo: todo, tag: tag, user: user)

      expect(duplicate_todos_tag).not_to be_valid
      expect(duplicate_todos_tag.errors[:todo_id]).to include("has already been taken")
    end
  end
end
