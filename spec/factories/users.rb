FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "User #{n}" }

    provider { "google" }
    uid { SecureRandom.uuid }

    trait :with_password do
      provider { nil }
      uid { nil }
      password { "password123" }
      password_confirmation { "password123" }
    end

    trait :github_oauth do
      provider { "github" }
    end
  end
end
