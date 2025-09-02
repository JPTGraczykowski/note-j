FactoryBot.define do
  factory :note do
    sequence(:title) { |n| "Note #{n}" }
    content { "This is the content of the note. It can be markdown formatted." }
    association :user
    folder { nil }

    trait :with_folder do
      association :folder
    end

    trait :with_content do |content_text|
      content { content_text }
    end

    trait :long_content do
      content { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " * 50 }
    end
  end
end
