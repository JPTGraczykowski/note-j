require 'rails_helper'

RSpec.describe Todo, type: :model do
  context "validations" do
    it "is valid with description and user" do
      todo = build(:todo)

      expect(todo).to be_valid
    end

    it "requires description" do
      todo = build(:todo, description: nil)

      expect(todo).not_to be_valid
      expect(todo.errors[:description]).to include("can't be blank")
    end

    it "requires user" do
      todo = build(:todo, user: nil)

      expect(todo).not_to be_valid
      expect(todo.errors[:user]).to include("must exist")
    end

    it "validates description length" do
      todo = build(:todo, description: "a" * 1001)

      expect(todo).not_to be_valid
      expect(todo.errors[:description]).to include("is too long (maximum is 1000 characters)")
    end

    it "defaults completed to false" do
      todo = create(:todo)

      expect(todo.completed).to be false
    end
  end

  context "associations" do
    it "belongs to user" do
      expect(Todo.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "belongs to todo_list" do
      expect(Todo.reflect_on_association(:todo_list).macro).to eq(:belongs_to)
    end
  end

  context "scopes" do
    it "finds todos for specific user" do
      user1 = create(:user)
      user2 = create(:user)
      todo1 = create(:todo, user: user1)
      todo2 = create(:todo, user: user2)

      user1_todos = Todo.for_user(user1)
      expect(user1_todos).to include(todo1)
      expect(user1_todos).not_to include(todo2)
    end

    it "finds completed todos" do
      user = create(:user)
      completed_todo = create(:todo, :completed, user: user)
      pending_todo = create(:todo, :pending, user: user)

      completed_todos = Todo.completed
      expect(completed_todos).to include(completed_todo)
      expect(completed_todos).not_to include(pending_todo)
    end

    it "finds pending todos" do
      user = create(:user)
      completed_todo = create(:todo, :completed, user: user)
      pending_todo = create(:todo, :pending, user: user)

      pending_todos = Todo.pending
      expect(pending_todos).to include(pending_todo)
      expect(pending_todos).not_to include(completed_todo)
    end

    it "orders todos by most recent" do
      user = create(:user)
      old_todo = create(:todo, user: user, created_at: 2.days.ago)
      new_todo = create(:todo, user: user, created_at: 1.day.ago)

      recent_todos = Todo.recent
      expect(recent_todos.first).to eq(new_todo)
      expect(recent_todos.last).to eq(old_todo)
    end
  end

  context "methods" do
    it "toggles completion status" do
      todo = create(:todo, completed: false)

      todo.toggle_completion!

      expect(todo.reload.completed).to be true
    end

    it "toggles completion status from completed to pending" do
      todo = create(:todo, completed: true)

      todo.toggle_completion!

      expect(todo.reload.completed).to be false
    end

    it "marks todo as completed" do
      todo = create(:todo, completed: false)

      todo.mark_completed!

      expect(todo.reload.completed).to be true
    end

    it "marks todo as pending" do
      todo = create(:todo, completed: true)

      todo.mark_pending!

      expect(todo.reload.completed).to be false
    end

    it "returns correct status for completed todo" do
      todo = create(:todo, completed: true)

      expect(todo.status).to eq("completed")
    end

    it "returns correct status for pending todo" do
      todo = create(:todo, completed: false)

      expect(todo.status).to eq("pending")
    end

    it "checks if todo is completed" do
      completed_todo = create(:todo, completed: true)
      pending_todo = create(:todo, completed: false)

      expect(completed_todo.completed?).to be true
      expect(pending_todo.completed?).to be false
    end

    it "checks if todo is pending" do
      completed_todo = create(:todo, completed: true)
      pending_todo = create(:todo, completed: false)

      expect(completed_todo.pending?).to be false
      expect(pending_todo.pending?).to be true
    end
  end
end
