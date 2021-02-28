require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:prefecture) { create :prefecture }
  let!(:another_prefecture) { create :prefecture,:another_prefecture }
  scenario 'ユーザー登録ができるか' do
    visit signup_path
    fill_in "user[user_name]", with: "test1"
    fill_in "user[email]", with: "test1@example.co.jp"
    fill_in "user[password]", with: "test01"
    fill_in "user[password_confirmation]", with: "test01"
    select '2000', from: 'user[birthday(1i)]'
    select '9', from: 'user[birthday(2i)]'
    select '12', from: 'user[birthday(3i)]'
    select '男', from: 'user[gender]'
    select '神奈川県', from: 'prefecture[prefecture_id]'
    select 'ギター',from: 'user[part][]'
    select 'J-POP',from: 'user[genre][]'
    fill_in "user[artist]", with: "X JAPAN"
    check 'user[agreement]'
    click_on "登録する"
    expect(page).to have_content("メールをチェックしてください")
  end

  scenario 'ログインできないか' do
    visit login_path
    fill_in "session[email]", with: "test1@example.co.jp"
    fill_in "session[password]", with: "1111111"
    click_button "ログイン"
    expect(page).to have_content "ログインに失敗しました"
  end

  feature 'ユーザー登録後', type: :system do
    let!(:user) { create :user1 }

    scenario 'ログインできているか' do
      login(user)
      expect(page).to have_selector('.alert-success', text: 'ログインしました')
    end
    background do
      login(user)
    end

    scenario 'ログアウトできるか' do
      click_on "ログアウト"
      expect(page).to have_selector('.alert-success', text: 'ログアウトしました')
    end

    scenario 'ユーザー情報編集ページに遷移できるか' do
      click_on "マイページ"
      click_on "プロフィール編集"
      expect(current_path).to eq edit_user_path(user)
    end

    scenario 'ユーザー情報編集ページのフォームは正しい値か' do
      click_on "マイページ"
      click_on "プロフィール編集"
      expect(page).to have_field("user[user_name]", with: "test1")
      expect(page).to have_field("user[email]", with: "test0@example.co.jp")
      expect(page).to have_field("user[birthday(1i)]", with: 2000)
      expect(page).to have_field("user[birthday(2i)]", with: 12)
      expect(page).to have_field("user[birthday(3i)]", with: 20)
      expect(page).to have_field("user[gender]", with: "男")
    end

    scenario 'ユーザー情報編集ができるか' do
      click_on "マイページ"
      click_on "プロフィール編集"
      fill_in "user[user_name]", with: "test2"
      fill_in "user[email]", with: "sample@example.co.jp"
      select '1993', from: 'user[birthday(1i)]'
      select '7', from: 'user[birthday(2i)]'
      select '25', from: 'user[birthday(3i)]'
      select '男', from: 'user[gender]'
      select '東京都', from: 'user[prefecture_id]'
      select 'ベース',from: 'user[part][]'
      select 'アニメ',from: 'user[genre][]'
      click_on "更新する"
      expect(page).to have_content("プロフィール更新しました")
      click_on "マイページ"
      expect(page).to have_field("user[user_name]", with: "test2")
      expect(page).to have_field("user[email]", with: "sample@example.co.jp")
      expect(page).to have_field("user[birthday]", with: 27)
      expect(page).to have_field("user[gender]", with: "男")
      expect(page).to have_field("user[prefecture]", with: "東京都")
      expect(page).to have_field("user[part]", with: "ベース")
      expect(page).to have_field("user[genre]", with: "アニメ")
    end

    scenario 'ユーザー退会処理ができるか' do
      click_on "マイページ"
      click_on "プロフィール編集"
      click_on "アカウント削除"
      expect(page).to have_content("アカウントを削除しました")
    end
  end
end
