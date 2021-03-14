require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user1) { create :user1 }
  let!(:user2) { create :user2 }
  let!(:user3) { create :user3 }
  let!(:micropost1) { create :micropost, user: user1 }
  let!(:micropost2) { create :micropost2, user: user2 }

  it 'メンバー検索が正しくできるか(単数)' do
    visit root_path
    click_link 'メンバーを探す'
    fill_in "q[user_name_cont]", with: "test1"
    click_button '探す'
    expect(page).to have_content("test1")
    expect(page).to have_content("担当パート：ギター,ドラム")
    expect(page).to have_content("好きなジャンル：J-POP,アニメ")
    expect(page).to have_content("活動地域：東京都")
    expect(page).not_to have_content("test2")
    expect(page).not_to have_content("担当パート：ギター,ベース")
    expect(page).not_to have_content("好きなジャンル：邦楽ロック,ジャズ")
    expect(page).not_to have_content("test3")
    expect(page).not_to have_content("担当パート：キーボード,コーラス")
    expect(page).not_to have_content("好きなジャンル：洋楽ロック, クラシック")
  end
  it 'メンバー検索が正しくできるか(複数)' do
    visit root_path
    click_link 'メンバーを探す'
    select '邦楽ロック', from: 'genre[]'
    select 'ギター', from: 'part[]'
    click_on '探す'
    expect(page).not_to have_content("test1")
    expect(page).not_to have_content("担当パート：ギター,ドラム")
    expect(page).not_to have_content("好きなジャンル：J-POP,アニメ")
    expect(page).to have_content("test2")
    expect(page).to have_content("担当パート：ギター,ベース")
    expect(page).to have_content("好きなジャンル：邦楽ロック,ジャズ")
    expect(page).to have_content("活動地域：東京都")
    expect(page).not_to have_content("test3")
    expect(page).not_to have_content("担当パート：キーボード,コーラス")
    expect(page).not_to have_content("好きなジャンル：洋楽ロック,クラシック")
  end
  it 'メンバー検索が正しくできるか(無条件)' do
    visit root_path
    click_link 'メンバーを探す'
    click_button '探す'
    expect(page).to have_selector("img[src$='default.png']")
    expect(page).to have_content("test1")
    expect(page).to have_content("担当パート：ギター,ドラム")
    expect(page).to have_content("好きなジャンル：J-POP,アニメ")
    expect(page).to have_content("活動地域：東京都")
    expect(page).to have_content("test2")
    expect(page).to have_content("担当パート：ギター,ベース")
    expect(page).to have_content("好きなジャンル：邦楽ロック,ジャズ")
    expect(page).to have_content("test3")
    expect(page).to have_content("担当パート：キーボード,コーラス")
    expect(page).to have_content("好きなジャンル：洋楽ロック,クラシック")
  end
  it '募集記事検索が正しくできるか(単数)' do
    visit root_path
    click_link '記事を探す'
    select 'ベース', from: 'part[]'
    click_button '探す'
    within first('.container') do
      expect(page).to have_selector("img[src$='default.png']")
      expect(page).to have_content("test2")
      expect(page).to have_content("東京都")
      expect(page).to have_content(25)
      expect(page).to have_content("テスト2")
      expect(page).to have_content("1分前.")
      expect(page).not_to have_content("test1")
      expect(page).not_to have_content("テスト1")
      expect(page).not_to have_content(20)
    end
  end
  it '募集記事検索が正しくできるか(複数)' do
    visit root_path
    click_link '記事を探す'
    select 'ギター', from: 'part[]'
    select 'J-POP', from: 'genre[]'
    fill_in "q[recruitment_min_age_eq]", with: 20
    fill_in "q[recruitment_max_age_eq]", with: 23
    click_button '探す'
    within first('.container') do
      expect(page).to have_selector("img[src$='default.png']")
      expect(page).to have_link("test1")
      expect(page).to have_content("東京都")
      expect(page).to have_content(20)
      expect(page).to have_content("テスト1")
      expect(page).to have_content("1分前.")
      expect(page).not_to have_content("test2")
      expect(page).not_to have_content(25)
      expect(page).not_to have_content("テスト2")
    end
  end

  it '募集記事検索が正しくできるか(無条件)' do
    visit root_path
    click_link '記事を探す'
    click_button '探す'
    within first('.container') do
      expect(page).to have_selector("img[src$='default.png']")
      expect(page).to have_link("test1")
      expect(page).to have_content("東京都")
      expect(page).to have_content(20)
      expect(page).to have_content("テスト1")
      expect(page).to have_content("1分前.")
      expect(page).to have_content("test2")
      expect(page).to have_content(25)
      expect(page).to have_content("テスト2")
    end
  end

  it 'キーワード検索が正しくできるか' do
    visit root_path
    fill_in "q[content_or_title_cont]", with: 1
    click_button '検索'
    within first('.container') do
      expect(page).to have_selector("img[src$='default.png']")
      expect(page).to have_link("test1")
      expect(page).to have_content("東京都")
      expect(page).to have_content(20)
      expect(page).to have_content("テスト1")
      expect(page).to have_content("1分前.")
      expect(page).not_to have_content("test2")
      expect(page).not_to have_content(25)
      expect(page).not_to have_content("テスト2")
    end
  end
  it 'キーワード検索が正しくできるか(無条件)' do
    visit root_path
    click_button '検索'
    within first('.container') do
      expect(page).to have_selector("img[src$='default.png']")
      expect(page).to have_link("test1")
      expect(page).to have_content("東京都")
      expect(page).to have_content(20)
      expect(page).to have_content("テスト1")
      expect(page).to have_content("1分前.")
      expect(page).to have_content("test2")
      expect(page).to have_content(25)
      expect(page).to have_content("テスト2")
    end
  end
end
