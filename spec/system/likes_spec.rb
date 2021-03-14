require 'rails_helper'

RSpec.describe 'likes', type: :system do
  let!(:post_user) { create :user1 }
  let!(:like_user) { create :user2 }
  let!(:micropost) { create :micropost, user: post_user }

  describe 'ログイン後' do
    before do
      login(like_user)
    end

    it 'ログイン済みユーザ/他人の投稿にはお気に入り追加解除できる' do
      visit root_path
      click_on micropost.title
      within('.detail_menu_col4') do
        expect do
          click_on 'お気に入り'
        end.to change { micropost.likes.count }.by(1)
      end
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      sleep 1
      retry
      has_no_selector?('.like-btn')
      has_selector?('.unlike-btn')
      within('.detail_menu_col4') do
        expect do
          click_on 'お気に入り'
        end.to change { micropost.likes.count }.by(-1)
        has_selector?('like-btn')
        has_no_selector?('unlike-btn')
      end
    end
  end
end
