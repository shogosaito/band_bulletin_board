FactoryBot.define do
  factory :notification do
    checked       { false }
    action        { "comment" }
  end
end
