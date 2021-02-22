require 'rails_helper'

RSpec.describe NotificationsController, type: :request do
  let(:user1) { create :user1 }
  let(:user2) { create :user2 }
  let!(:notification) { create :notification, visitor: user1, visited: user2 }

  before do
    sign_in user2
  end

  describe 'GET #index' do
    it 'リクエストが成功すること' do
      get notifications_url
      expect(response.status).to eq 200
    end

    it '通知が表示されていること' do
      get notifications_url
      expect(response.body).to include "test1</a>さんが<a>あなたの投稿</a>にコメントしました。コメント内容「 」"
    end
  end

  describe 'GET #show' do
    it 'リクエストが成功すること' do
      get notifications_url notification
      expect(response.status).to eq 200
    end
  end

  describe 'DELETE #destroy' do
    it 'リクエストが成功すること' do
      delete notification_delete_url
      expect(response.status).to eq 302
    end

    it '通知が削除されること' do
      expect do
        delete notification_delete_url
      end.to change(Notification, :count).by(-1)
    end

    it '通知一覧にリダイレクトすること' do
      delete notification_delete_url
      expect(response).to redirect_to(notification_url)
    end
  end
end
