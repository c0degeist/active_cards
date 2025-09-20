FactoryBot.define do
  factory :topic do
    sequence(:title) { |n| "example topic #{n}" }
  end
end
