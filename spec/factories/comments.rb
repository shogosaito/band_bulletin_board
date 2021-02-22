FactoryBot.define do
  factory :comment do
    content { "テストコメント" }
    trait :invalid do
      content { nil }
    end
  end
  factory :comment2, class: Comment do
    content { "テストコメント2" }
  end
end
