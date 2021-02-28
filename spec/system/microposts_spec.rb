require 'rails_helper'

RSpec.describe 'Microposts', type: :system do
  let!(:prefecture) { create :prefecture }
  let!(:another_prefecture) { create :prefecture,:another_prefecture }
  let!(:user) { create :user1 }
  before do
  login(user)
  end
  scenario '募集記事が投稿できるか' do
    click_on "記事投稿"
    select '募集', from: 'micropost[content_type]'
    fill_in "micropost[title]", with: "募集記事"
    fill_in "micropost[content]", with: "ドラムとボーカルの募集です。"
    select '神奈川県', from: 'prefecture[prefecture_id]'
    select '趣味志向', from: 'micropost[activity_direction]'
    find("#micropost_music_type_コピー").click
    select '神奈川県', from: 'prefecture[prefecture_id]'
    within('.recruitment-group') do
      fill_in "micropost[recruitment_min_age]", with: 19
      fill_in "micropost[recruitment_max_age]", with: 35
      select '男性', from: 'micropost[gender]'
      find("#micropost_activity_day_土").click
      find("#micropost_activity_day_日").click
      fill_in "micropost[demo_sound_source]", with: 'http://localhost:3000/test'
  end
    click_on '投稿'
    expect(page).to have_content("投稿しました!")
    within('.post_info') do
      expect(page).to have_content(user.user_name)
      expect(page).to have_content(user.prefecture.name)
      expect(page).to have_content(20)
      expect(page).to have_content("ドラムとボーカルの募集です。")
      expect(page).to have_content("1分前.")
    end
    click_link '募集記事'
  end
  scenario'投稿記事の内容が正しいか' do
  click_on 'トップ'
  
  end

  scenario '加入記事が投稿できるか' do
    click_on "記事投稿"
    select '加入', from: 'micropost[content_type]'
    fill_in "micropost[title]", with: "加入記事"
    fill_in "micropost[content]", with: "ドラムとボーカルの募集です。"
    select '神奈川県', from: 'prefecture[prefecture_id]'
    select '趣味志向', from: "micropost[activity_direction]"
    find("#micropost_music_type_オリジナル").click
    within('.join-group') do
      select 'ボーカル',from: 'micropost[part][]'
      select 'J-POP',from: 'micropost[genre][]'
      find("#micropost_activity_day_日").click
      find("#micropost_activity_day_祝日").click
      fill_in "micropost[demo_sound_source]", with: 'http://localhost:3000/test'
  end
    click_on '投稿'
    expect(page).to have_content("投稿しました!")
  end
end
