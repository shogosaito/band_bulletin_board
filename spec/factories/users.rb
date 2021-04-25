FactoryBot.define do
  factory :user1, :class => "User" do
    user_name { "test1" }
    email { "test0@example.co.jp" }
    password { "test01" }
    password_confirmation { "test01" }
    prefecture_id { 12 }
    gender { "男" }
    genre { ["J-POP", "アニメ"] }
    artist { "X JAPAN" }
    url { "http://localhost:3000" }
    agreement { "1" }
    birthday { '2000-12-20' }
    part { ["ギター", "ドラム"] }
    activated { true }
    activated_at { Time.zone.now }
    after(:build) do |user1|
      user1.user_image.attach(io: File.open('spec/support/images/default.png'),
                              filename: 'default.png', content_type: 'image/png')
    end

    trait :invalid do
      user_name { "abcdefjhijklmnopqr" }
      email { "test11@example.co.jp" }
    end
    prefecture
  end

  factory :user2, :class => "User" do
    user_name { "test2" }
    email { "test2@example.co.jp" }
    password { "test02" }
    password_confirmation { "test02" }
    prefecture_id { 12 }
    gender  { "男" }
    genre { ["邦楽ロック", "ジャズ"] }
    artist { "X JAPAN" }
    url { "http://localhost:3000/" }
    agreement { "1" }
    birthday { '1995-10-23' }
    part { ["ギター", "ベース"] }
    activated { true }
    activated_at { Time.zone.now }
    after(:build) do |user2|
      user2.user_image.attach(io: File.open('spec/support/images/default.png'),
                              filename: 'default.png', content_type: 'image/png')
    end

    trait :invalid do
      user_name { "abcdefjhijklmnopqr" }
      email { "test22@example.co.jp" }
    end
    prefecture
  end

  factory :user3, :class => "User" do
    user_name { "test3" }
    email { "test3@example.co.jp" }
    password { "test03" }
    password_confirmation { "test03" }
    prefecture_id { 12 }
    gender  { "男" }
    genre { ["洋楽ロック", "クラシック"] }
    artist { "X JAPAN" }
    url { "http://localhost:3000/" }
    agreement { "1" }
    birthday { Faker::Date.birthday }
    part { ["キーボード", "コーラス"] }
    activated { true }
    activated_at { Time.zone.now }
    after(:build) do |user3|
      user3.user_image.attach(io: File.open('spec/support/images/default.png'),
                              filename: 'default.png', content_type: 'image/png')
    end

    trait :invalid do
      user_name { "abcdefjhijklmnopqr" }
      email { "test33@example.co.jp" }
    end
    prefecture
  end

  factory :user4, :class => "User" do
    user_name { "test4" }
    email { "test4@example.co.jp" }
    prefecture_id { 12 }
    gender  { "男" }
    genre { ["洋楽ロック", "クラシック"] }
    artist { "X JAPAN" }
    url { "http://localhost:3000/" }
    agreement { "1" }
    birthday { Faker::Date.birthday }
    part { ["キーボード", "コーラス"] }
    activated { true }
    activated_at { Time.zone.now }
    prefecture
  end
end
