FactoryBot.define do
  factory :todo_list do
    sequence(:title) { |n| "Todo List #{n}" }
    completed { false }
    association :user

    trait :completed do
      completed { true }
    end

    trait :pending do
      completed { false }
    end

    trait :with_todos do
      transient do
        todos_count { 3 }
      end

      after(:create) do |todo_list, evaluator|
        create_list(:todo, evaluator.todos_count, todo_list: todo_list, user: todo_list.user)
      end
    end
  end
end
