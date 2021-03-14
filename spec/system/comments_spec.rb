require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let!(:post_user) { create :user1 }
  let!(:comment_user) { create :user2 }
  let!(:micropost) { create :micropost, user: post_user }

  before do
    login(comment_user)
  end

  it 'ログイン済みユーザ/他人の投稿にコメントできる' do
    visit root_path
    click_on micropost.title
    fill_in "comment[content]", with: "テストコメント1"
    expect  do
      click_button 'コメントを書く'
    end.to change { micropost.comments.count }.by(1)
    expect(page).to have_content("コメントしました!")
    expect(page).to have_selector("img[src$='default.png']")
    expect(page).to have_content(comment_user.user_name)
    expect(page).to have_content("テストコメント")
    expect(page).to have_content("1分前")
    expect(page).to have_link("削除")
  end
  it '自分のコメントは削除できる' do
    visit root_path
    click_on micropost.title
    fill_in "comment[content]", with: "テストコメント2"
    expect  do
      click_button 'コメントを書く'
    end.to change { micropost.comments.count }.by(1)
    expect do
      click_link("削除")
    end.to change { micropost.comments.count }.by(-1)
    expect(page).not_to have_selector("img[src$='default.png']")
    expect(page).not_to have_content(comment_user.user_name)
    expect(page).not_to have_content("テストコメント")
    expect(page).not_to have_content("1分前")
    expect(page).not_to have_link("削除")
  end
end
