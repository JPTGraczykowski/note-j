FactoryBot.define do
  factory :todo do
    sequence(:description) { |n| "Todo item #{n}" }
    completed { false }
    association :user

    trait :completed do
      completed { true }
    end

    trait :pending do
      completed { false }
    end
  end
end
