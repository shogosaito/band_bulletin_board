require 'rails_helper'

RSpec.describe 'Notifications', type: :system do
  let!(:post_user) { create :user1 }
  let!(:comment_user) { create :user2 }
  let!(:like_user) { create :user3 }
  let!(:micropost) { create :micropost, user: post_user }

  it 'ログイン済みユーザ/投稿へのお気に入り、コメントの通知が来るか' do
    # micropost = create(:micropost, user: post_user)
    login(comment_user)
    visit root_path
    within('.post_info') do
      click_link micropost.title
    end
    fill_in "comment[content]", with: "テストコメント"
    click_button 'コメントを書く'
    click_link 'ログアウト'

    login(like_user)
    visit root_path
    within('.post_info') do
      click_link micropost.title
    end
    within('.detail_menu_col4') do
      click_on 'お気に入り'
    end
  rescue Selenium::WebDriver::Error::ElementNotFound
    sleep 1
    within('.navbar-collapse') do
      click_link 'ログアウト'
    end

    login(post_user)
    within('.navbar-nav') do
      has_selector?('fa-bell')
    end
    click_on '通知'
    has_no_selector?('fa-bell')
    expect do
      within('.users-index') do
        expect(page).to have_selector("img[src$='default.png']")
        expect(page).to have_content(comment_user.user_name + "さんがあなたの投稿にコメントしました。コメント内容「 テストコメント」 (1分前)")
        expect(page).to have_content(like_user.user_name + "さんがあなたの投稿をお気に入りに追加しました。(1分前)")
      end
    end.to change { micropost.comments.count }.by(1)
    expect do
      click_link("全削除")
    end.to change { micropost.comments.count }.by(-2)
    expect(page).not_to have_selector("img[src$='default.png']")
    expect(page).not_to have_content(comment_user.user_name + "さんがあなたの投稿にコメントしました。コメント内容「 テストコメント」 (1分前)")
    expect(page).not_to have_content(like_user.user_name + "さんがあなたの投稿をお気に入りに追加しました。(1分前)")
  end
end
