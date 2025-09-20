FactoryBot.define do
  factory :active_card do
    question { 'Is this an example question?' }
    answer { 'Yes, this is an example answer' }

    association :deck

    trait :pending do
      next_recall { Date.today - 1 }
    end

    trait :done do
      next_recall { Date.today + 1 }
    end
  end
end
