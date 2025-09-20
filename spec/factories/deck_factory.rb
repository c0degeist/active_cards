FactoryBot.define do
  factory :deck do
    sequence(:title) { |n| "Example Deck #{n}" }
    association :topic
  end
end
