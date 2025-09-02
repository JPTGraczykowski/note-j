FactoryBot.define do
  factory :todos_tag do
    association :todo
    association :tag
    association :user
  end
end
