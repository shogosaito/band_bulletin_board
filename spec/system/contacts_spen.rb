require 'rails_helper'

RSpec.describe 'Microposts', type: :system do
  let!(:post_user) { create :user1 }
  let!(:micropost) { create :micropost, user: post_user }
  let!(:user) { create :user2 }

  before do
    login(user)
  end

  it 'メッセージが送信できること' do
    visit micropost_path micropost
    click_link "メッセージ"
    fill_in "contact[message]", with: "テストメッセージ"
    expect do
      click_on "送信"
    end.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(ActionMailer::Base.deliveries[0].to).to eq ["test0@example.co.jp"]
    expect(ActionMailer::Base.deliveries[0].subject).to eq "test2様からメッセージが届いています"
    expect(page).to have_content("メッセージを送りました")
  end
end
