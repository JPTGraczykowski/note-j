FactoryBot.define do
  factory :folder do
    sequence(:name) { |n| "Folder #{n}" }
    association :user
    parent_id { nil }
  end
end
