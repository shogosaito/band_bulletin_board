require 'rails_helper'

RSpec.describe 'Microposts', type: :system do
  let!(:prefecture) { create :prefecture }
  let!(:another_prefecture) { create :prefecture, :another_prefecture }
  let!(:user) { create :user1 }
  let!(:micropost) { create :micropost, user: user }

  before do
    login(user)
  end

  it '募集記事が投稿できる/投稿記事の内容が正しいか' do
    click_on "記事投稿"
    select '募集', from: 'micropost[content_type]'
    fill_in "micropost[title]", with: "募集記事"
    fill_in "micropost[content]", with: "ドラムとボーカルの募集です。"
    select '神奈川県', from: 'prefecture[prefecture_id]'
    select '趣味志向', from: 'micropost[activity_direction]'
    find("#micropost_music_type_コピー").click
    select '神奈川県', from: 'prefecture[prefecture_id]'
    within('.recruitment-group') do
      select 'ドラム', from: 'micropost[part][]'
      select 'ボーカル', from: 'micropost[part][]'
      select 'J-POP', from: 'micropost[genre][]'
      fill_in "micropost[recruitment_min_age]", with: 19
      fill_in "micropost[recruitment_max_age]", with: 35
      select '男性', from: 'micropost[gender]'
      find("#micropost_activity_day_土").click
      find("#micropost_activity_day_日").click
    end
    fill_in "micropost[demo_sound_source]", with: "http://localhost:3000/test"
    click_on '投稿'
    expect(page).to have_content("投稿しました!")
    expect(page).to have_selector("img[src$='default.png']")
    expect(page).to have_content("募集記事")
    expect(page).to have_content("東京都")
    expect(page).to have_content(20)
    expect(page).to have_content("ドラムとボーカルの募集です。")
    expect(page).to have_content("1分前.")
    click_link '募集記事'
    expect(page).to have_content("募集記事")
    within(".micropost-info") do
      expect(page).to have_content("ドラムとボーカルの募集です。")
      expect(page).to have_content("募集")
      expect(page).to have_content("神奈川県")
      expect(page).to have_content("土日")
      expect(page).to have_content("趣味志向")
      expect(page).to have_content("コピー")
      expect(page).to have_content("男性")
      expect(page).to have_text('19〜35')
      expect(page).to have_content("ボーカル,ドラム")
      expect(page).to have_content("J-POP")
      expect(page).to have_content("http://localhost:3000/test")
    end
    expect(page).to have_content("1分前")
    expect(page).to have_link("編集")
    expect(page).to have_link("削除")
    within(".detail_menu_col4") do
      expect(page).to have_link("プロフィール")
      expect(page).to have_link("お気に入り")
      expect(page).to have_link("メッセージ")
      expect(page).to have_link("閉じる")
    end
    expect(page).to have_content("コメント一覧")
    expect(page).to have_content("コメント投稿者")
    expect(page).to have_content("コメント内容")
    expect(page).to have_button("コメントを書く")
  end

  it '加入記事が投稿できるか/投稿記事の内容が正しいか' do
    visit root_path
    click_on "記事投稿"
    select '加入', from: 'micropost[content_type]'
    fill_in "micropost[title]", with: "加入記事"
    fill_in "micropost[content]", with: "ドラムで加入募集です。"
    select '神奈川県', from: 'prefecture[prefecture_id]'
    select 'プロ志向', from: "micropost[activity_direction]"
    find("#micropost_music_type_オリジナル").click
    within('.join-group') do
      select 'ボーカル', from: 'micropost[part][]'
      select 'J-POP', from: 'micropost[genre][]'
      find("#micropost_activity_day_日").click
      find("#micropost_activity_day_祝日").click
    end
    fill_in "micropost[demo_sound_source]", with: 'http://localhost:3000/test'
    click_on '投稿'
    expect(page).to have_content("投稿しました!")

    expect(page).to have_selector("img[src$='default.png']")
    expect(page).to have_content("加入記事")
    expect(page).to have_content("東京都")
    expect(page).to have_content(20)
    expect(page).to have_content("ドラムで加入募集です。")
    expect(page).to have_content("1分前.")

    click_on '加入記事'
    expect(page).to have_content("加入記事")
    within(".micropost-info") do
      expect(page).to have_content("ドラムで加入募集です。")
      expect(page).to have_content("募集")
      expect(page).to have_content("神奈川県")
      expect(page).to have_content("日祝日")
      expect(page).to have_content("プロ志向")
      expect(page).to have_content("オリジナル")
      expect(page).to have_content("ボーカル")
      expect(page).to have_content("J-POP")
      expect(page).to have_content("http://localhost:3000/test")
    end
    expect(page).to have_link("編集")
    expect(page).to have_link("削除")

    within(".detail_menu_col4") do
      expect(page).to have_link("プロフィール")
      expect(page).to have_link("お気に入り")
      expect(page).to have_link("メッセージ")
      expect(page).to have_link("閉じる")
    end
    expect(page).to have_content("コメント一覧")
    expect(page).to have_content("コメント投稿者")
    expect(page).to have_content("コメント内容")
    expect(page).to have_button("コメントを書く")
  end

  it '自分の投稿記事の編集ができるか' do
    visit root_path
    click_on micropost.title
    click_on '編集'
    fill_in "micropost[title]", with: "編集記事"
    fill_in "micropost[content]", with: "ギターとキーボードの募集です。"
    select '東京都', from: 'prefecture[prefecture_id]'
    select 'プロ志向', from: 'micropost[activity_direction]'
    find("#micropost_music_type_オリジナル").click
    select '神奈川県', from: 'prefecture[prefecture_id]'
    within('.recruitment-group') do
      select 'ギター', from: 'micropost[part][]'
      select 'キーボード', from: 'micropost[part][]'
      select 'アニメ', from: 'micropost[genre][]'
      select '邦楽ロック', from: 'micropost[genre][]'
      fill_in "micropost[recruitment_min_age]", with: 20
      fill_in "micropost[recruitment_max_age]", with: 25
      select '女性', from: 'micropost[gender]'
      find("#micropost_activity_day_金").click
      find("#micropost_activity_day_祝日").click
    end
    fill_in "micropost[demo_sound_source]", with: 'http://localhost:3000'
    click_on '編集'
    expect(page).to have_content("投稿を編集しました")
    expect(page).to have_content("編集記事")
    expect(page).to have_content("ギターとキーボードの募集です。")
    expect(page).to have_content("神奈川県")
    expect(page).to have_content("金祝日")
    expect(page).to have_content("プロ志向")
    expect(page).to have_content("オリジナル")
    expect(page).to have_content("女性")
    expect(page).to have_text('20〜25')
    expect(page).to have_content("ギター,キーボード")
    expect(page).to have_content("アニメ,邦楽ロック")
    expect(page).to have_content("http://localhost:3000")
    expect(page).to have_content("1分前")
    expect(page).not_to have_content("ドラムとボーカルの募集です。")
    expect(page).not_to have_content("東京都")
    expect(page).not_to have_content("土日")
    expect(page).not_to have_content("趣味志向")
    expect(page).not_to have_content("コピー")
    expect(page).not_to have_content("男性")
    expect(page).not_to have_text('19〜35')
    expect(page).not_to have_content("ボーカル,ドラム")
    expect(page).not_to have_content("J-POP")
    expect(page).not_to have_content("http://localhost:3000/test")
  end

  it '自分の投稿記事が削除できること' do
    visit root_path
    click_on micropost.title
    expect do
      click_on '削除'
    end.to change(Micropost, :count).by(-1)
    expect(page).to have_content("投稿を削除しました")
  end
end
