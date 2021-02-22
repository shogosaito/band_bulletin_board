FactoryBot.define do
  factory :prefecture do
    id { 12 }
    name { "東京都" }

    initialize_with do
      Prefecture.find_or_initialize_by(
        id: 12,
        name: "東京都"
      )
    end
  end
  # initialize_with do
  #   Prefecture.find_or_initialize_by(
  #     id: 13,
  #     name: "神奈川県"
  #   )
  # end
end
