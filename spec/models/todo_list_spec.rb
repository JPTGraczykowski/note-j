require 'rails_helper'

RSpec.describe TodoList, type: :model do
  context "validations" do
    it "is valid with title and user" do
      todo_list = build(:todo_list)

      expect(todo_list).to be_valid
    end

    it "requires title" do
      todo_list = build(:todo_list, title: nil)

      expect(todo_list).not_to be_valid
      expect(todo_list.errors[:title]).to include("can't be blank")
    end

    it "requires user" do
      todo_list = build(:todo_list, user: nil)

      expect(todo_list).not_to be_valid
      expect(todo_list.errors[:user]).to include("must exist")
    end

    it "validates title length" do
      todo_list = build(:todo_list, title: "a" * 501)

      expect(todo_list).not_to be_valid
      expect(todo_list.errors[:title]).to include("is too long (maximum is 500 characters)")
    end

    it "defaults completed to false" do
      todo_list = create(:todo_list)

      expect(todo_list.completed).to be false
    end
  end

  context "associations" do
    it "belongs to user" do
      expect(TodoList.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "has many todos" do
      expect(TodoList.reflect_on_association(:todos).macro).to eq(:has_many)
    end

    it "destroys associated todos when deleted" do
      user = create(:user)
      todo_list = create(:todo_list, user: user)
      todo1 = create(:todo, user: user, todo_list: todo_list)
      todo2 = create(:todo, user: user, todo_list: todo_list)

      expect { todo_list.destroy }.to change { Todo.count }.by(-2)
    end
  end

  context "scopes" do
    it "finds todo lists for specific user" do
      user1 = create(:user)
      user2 = create(:user)
      todo_list1 = create(:todo_list, user: user1)
      todo_list2 = create(:todo_list, user: user2)

      user1_todo_lists = TodoList.for_user(user1)
      expect(user1_todo_lists).to include(todo_list1)
      expect(user1_todo_lists).not_to include(todo_list2)
    end

    it "finds completed todo lists" do
      user = create(:user)
      completed_todo_list = create(:todo_list, :completed, user: user)
      pending_todo_list = create(:todo_list, :pending, user: user)

      completed_todo_lists = TodoList.completed
      expect(completed_todo_lists).to include(completed_todo_list)
      expect(completed_todo_lists).not_to include(pending_todo_list)
    end

    it "finds pending todo lists" do
      user = create(:user)
      completed_todo_list = create(:todo_list, :completed, user: user)
      pending_todo_list = create(:todo_list, :pending, user: user)

      pending_todo_lists = TodoList.pending
      expect(pending_todo_lists).to include(pending_todo_list)
      expect(pending_todo_lists).not_to include(completed_todo_list)
    end

    it "orders todo lists by most recent" do
      user = create(:user)
      old_todo_list = create(:todo_list, user: user, created_at: 2.days.ago)
      new_todo_list = create(:todo_list, user: user, created_at: 1.day.ago)

      recent_todo_lists = TodoList.recent
      expect(recent_todo_lists.first).to eq(new_todo_list)
      expect(recent_todo_lists.last).to eq(old_todo_list)
    end
  end

  context "methods" do
    it "toggles completion status" do
      todo_list = create(:todo_list, completed: false)

      todo_list.toggle_completion!

      expect(todo_list.reload.completed).to be true
    end

    it "toggles completion status from completed to pending" do
      todo_list = create(:todo_list, completed: true)

      todo_list.toggle_completion!

      expect(todo_list.reload.completed).to be false
    end

    it "marks todo list as completed" do
      todo_list = create(:todo_list, completed: false)

      todo_list.mark_completed!

      expect(todo_list.reload.completed).to be true
    end

    it "marks todo list as pending" do
      todo_list = create(:todo_list, completed: true)

      todo_list.mark_pending!

      expect(todo_list.reload.completed).to be false
    end

    it "returns correct status for completed todo list" do
      todo_list = create(:todo_list, completed: true)

      expect(todo_list.status).to eq("completed")
    end

    it "returns correct status for pending todo list" do
      todo_list = create(:todo_list, completed: false)

      expect(todo_list.status).to eq("pending")
    end

    it "checks if todo list is completed" do
      completed_todo_list = create(:todo_list, completed: true)
      pending_todo_list = create(:todo_list, completed: false)

      expect(completed_todo_list.completed?).to be true
      expect(pending_todo_list.completed?).to be false
    end

    it "checks if todo list is pending" do
      completed_todo_list = create(:todo_list, completed: true)
      pending_todo_list = create(:todo_list, completed: false)

      expect(completed_todo_list.pending?).to be false
      expect(pending_todo_list.pending?).to be true
    end

    it "calculates progress percentage" do
      user = create(:user)
      todo_list = create(:todo_list, user: user)
      create(:todo, user: user, todo_list: todo_list, completed: true)
      create(:todo, user: user, todo_list: todo_list, completed: true)
      create(:todo, user: user, todo_list: todo_list, completed: false)
      create(:todo, user: user, todo_list: todo_list, completed: false)

      # 2 out of 4 completed = 50%
      expect(todo_list.progress_percentage).to eq(50)
    end

    it "returns 0 progress for empty todo list" do
      todo_list = create(:todo_list)

      expect(todo_list.progress_percentage).to eq(0)
    end

    it "checks if all todos are completed" do
      user = create(:user)
      todo_list = create(:todo_list, user: user)
      create(:todo, user: user, todo_list: todo_list, completed: true)
      create(:todo, user: user, todo_list: todo_list, completed: true)

      expect(todo_list.all_todos_completed?).to be true
    end

    it "returns false when not all todos are completed" do
      user = create(:user)
      todo_list = create(:todo_list, user: user)
      create(:todo, user: user, todo_list: todo_list, completed: true)
      create(:todo, user: user, todo_list: todo_list, completed: false)

      expect(todo_list.all_todos_completed?).to be false
    end

    it "returns false for empty todo list" do
      todo_list = create(:todo_list)

      expect(todo_list.all_todos_completed?).to be false
    end

    it "counts pending todos" do
      user = create(:user)
      todo_list = create(:todo_list, user: user)
      create(:todo, user: user, todo_list: todo_list, completed: true)
      create(:todo, user: user, todo_list: todo_list, completed: false)
      create(:todo, user: user, todo_list: todo_list, completed: false)

      expect(todo_list.pending_todos_count).to eq(2)
    end

    it "counts completed todos" do
      user = create(:user)
      todo_list = create(:todo_list, user: user)
      create(:todo, user: user, todo_list: todo_list, completed: true)
      create(:todo, user: user, todo_list: todo_list, completed: true)
      create(:todo, user: user, todo_list: todo_list, completed: false)

      expect(todo_list.completed_todos_count).to eq(2)
    end
  end
end
