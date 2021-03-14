require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:prefecture) { create :prefecture }
  let!(:another_prefecture) { create :prefecture, :another_prefecture }
  let!(:user1) { create :user1 }
  let!(:micropost1) { create :micropost, user: user1 }
  let!(:user2) { create :user2 }
  let!(:micropost2) { create :micropost2, user: user2 }

  describe 'ユーザ登録、ログイン/ログアウト' do
    it 'ユーザー登録ができるか' do
      visit signup_path
      fill_in "user[user_name]", with: "test10"
      fill_in "user[email]", with: "test10@example.co.jp"
      fill_in "user[password]", with: "test01"
      fill_in "user[password_confirmation]", with: "test01"
      select '2000', from: 'user[birthday(1i)]'
      select '9', from: 'user[birthday(2i)]'
      select '12', from: 'user[birthday(3i)]'
      select '男', from: 'user[gender]'
      select '神奈川県', from: 'prefecture[prefecture_id]'
      select 'ギター', from: 'user[part][]'
      select 'J-POP', from: 'user[genre][]'
      fill_in "user[artist]", with: "X JAPAN"
      check 'user[agreement]'
      expect do
        click_on "登録する"
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(ActionMailer::Base.deliveries[0].to).to eq ["test10@example.co.jp"]
      expect(ActionMailer::Base.deliveries[0].subject).to eq "会員登録が完了しました。"
      expect(page).to have_content("メールをチェックしてください")
    end

    it 'ログインできないか' do
      visit login_path
      fill_in "session[email]", with: "test1@example.co.jp"
      fill_in "session[password]", with: "1111111"
      click_button "ログイン"
      expect(page).to have_content "ログインに失敗しました"
    end

    feature 'ユーザー登録後', type: :system do
      it 'ログインできているか' do
        login(user1)
        expect(page).to have_selector('.alert-success', text: 'ログインしました')
      end

      it 'ログアウトできるか' do
        login(user1)
        click_on "ログアウト"
        expect(page).to have_selector('.alert-success', text: 'ログアウトしました')
      end
    end

    describe 'マイページ、ユーザ編集' do
      before do
        login(user1)
      end

      it 'マイページの情報が正常か' do
        visit root_path
        click_on micropost2.title
        within('.detail_menu_col4') do
          click_on 'お気に入り'
        end
        # rescue Selenium::WebDriver::Error::StaleElementReferenceError
        sleep 1
        visit root_path
        click_on "マイページ"
        expect(page).to have_field("user[user_name]", with: "test1")
        expect(page).to have_field("user[email]", with: "test0@example.co.jp")
        expect(page).to have_field("user[birthday]", with: 20)
        expect(page).to have_field("user[gender]", with: "男")
        expect(page).to have_field("user[prefecture]", with: "東京都")
        expect(page).to have_field("user[part]", with: "ギター,ドラム")
        expect(page).to have_field("user[genre]", with: "J-POP,アニメ")
        expect(page).to have_field("user[artist]", with: "X JAPAN")
        expect(page).to have_selector("img[src$='default.png']")
        expect(page).to have_link(micropost1.content)
        expect(page).to have_link(micropost2.content)
      end

      it 'ユーザー情報編集ページに遷移できるか' do
        click_on "マイページ"
        click_on "プロフィール編集"
        expect(current_path).to eq edit_user_path(user1)
      end

      it 'ユーザー情報編集ページのフォームは正しい値か' do
        click_on "マイページ"
        click_on "プロフィール編集"
        expect(page).to have_field("user[user_name]", with: "test1")
        expect(page).to have_field("user[email]", with: "test0@example.co.jp")
        expect(page).to have_field("user[birthday(1i)]", with: 2000)
        expect(page).to have_field("user[birthday(2i)]", with: 12)
        expect(page).to have_field("user[birthday(3i)]", with: 20)
        expect(page).to have_field("user[gender]", with: "男")
      end

      it 'ユーザー情報編集ができるか' do
        click_on "マイページ"
        click_on "プロフィール編集"
        fill_in "user[user_name]", with: "test99"
        fill_in "user[email]", with: "sample@example.co.jp"
        select '1993', from: 'user[birthday(1i)]'
        select '7', from: 'user[birthday(2i)]'
        select '25', from: 'user[birthday(3i)]'
        select '男', from: 'user[gender]'
        select '東京都', from: 'user[prefecture_id]'
        select 'ベース', from: 'user[part][]'
        select 'アニメ', from: 'user[genre][]'
        attach_file 'user[user_image]', "#{Rails.root}/spec/factories/images/sample.png"
        click_on "更新する"
        expect(page).to have_content("プロフィール更新しました")
        click_on "マイページ"
        expect(page).to have_field("user[user_name]", with: "test99")
        expect(page).to have_field("user[email]", with: "sample@example.co.jp")
        expect(page).to have_field("user[birthday]", with: 27)
        expect(page).to have_field("user[gender]", with: "男")
        expect(page).to have_field("user[prefecture]", with: "東京都")
        expect(page).to have_field("user[part]", with: "ベース")
        expect(page).to have_field("user[genre]", with: "アニメ")
        expect(page).to have_selector("img[src$='sample.png']")
      end

      it 'ユーザー退会処理ができるか' do
        click_on "マイページ"
        click_on "プロフィール編集"
        click_on "アカウント削除"
        expect(page).to have_content("アカウントを削除しました")
      end
    end
  end
end
