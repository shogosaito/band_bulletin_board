# # ユーザー
# # User.create!(user_name:  "Example User",
# #   full_name: "as",
# #     password:              "foobar",
# #     password_confirmation: "foobar",
# #     activated: true,
# #     activated_at: Time.zone.now)
#
# 99.times do |n|
#   name  = Faker::Name.name
#   password = "password"
#   User.create!(user_name:  name,
#         full_name:  name,
#         password:              password,
#         password_confirmation: password,
#         activated: true,
#         activated_at: Time.zone.now)
# end
#
# # マイクロポスト
# users = User.order(:created_at).take(6)
# # 50.times do
# #   content = Faker::Lorem.sentence(word_count: 5)
# #   users.each { |user| user.microposts.create!(content: content) }
# # end
#
# # 以下のリレーションシップを作成する
# users = User.all
# user  = users.first
# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }
