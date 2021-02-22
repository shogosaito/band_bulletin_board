require 'rails_helper'

RSpec.describe BandBulletinBoardsController, type: :request do
  describe 'GET #home' do
    let!(:user1) { create :user1 }
    let!(:user2) { create :user2 }
    let!(:micropost1) { create(:micropost, user: user1) }
    let!(:micropost2) { create(:micropost, user: user2) }

    it 'リクエストが成功すること' do
      get root_url
      expect(response.status).to eq 200
    end

    it 'ユーザー名が表示されていること' do
      get root_url
      expect(response.body).to include "test1"
      expect(response.body).to include "test2"
    end
  end
end
