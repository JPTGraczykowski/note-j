FactoryBot.define do
  factory :notes_tag do
    association :note
    association :tag
    association :user
  end
end
