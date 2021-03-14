FactoryBot.define do
  factory :micropost do
    title { "test1" }
    genre { ["J-POP,アニメ"] }
    content_type { "募集" }
    content { "テスト1" }
    prefecture_id { 12 }
    music_type { ["コピー"] }
    recruitment_min_age { "20" }
    recruitment_max_age { "23" }
    gender { "男" }
    demo_sound_source { "http://localhost:3000/" }
    activity_direction { "プロ志向" }
    part { ["ギター,ドラム"] }
    activity_day { ["月,火,日"] }
    trait :invalid do
      title { nil }
    end
    prefecture
  end

  factory :micropost2, class: Micropost do
    title { "test2" }
    genre { ["邦楽ロック", "ジャズ"] }
    content_type { "募集" }
    content { "テスト2" }
    prefecture_id { 12 }
    music_type { ["コピー"] }
    recruitment_min_age { "25" }
    recruitment_max_age { "30" }
    gender { "男" }
    demo_sound_source { "http://localhost:3000/" }
    activity_direction { "プロ志向" }
    part { ["ギター,ベース"] }
    activity_day { ["月,火,日"] }
    trait :invalid do
      title { nil }
    end
    prefecture
  end
end
