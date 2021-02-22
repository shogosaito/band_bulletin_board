require 'rails_helper'

RSpec.describe LikesController, type: :request do
  let!(:user1) { create :user1 }
  let!(:user2) { create :user2 }
  let!(:user3) { create :user3 }
  let!(:micropost) { create :micropost, user: user2 }
  let!(:micropost2) { create :micropost2, user: user2 }
  let!(:like) { create :like, user_id: user1.id, micropost_id: micropost2.id }

  before do
    sign_in user1
  end

  describe "POST #create" do
    context 'パラメータが妥当な場合' do
      it "リクエストが成功すること" do
        post like_path(micropost_id: micropost.id), params: { micropost_id: micropost.id, user_id: user1.id }, xhr: true
        expect(response.status).to eq 200
      end

      it "お気に入りが登録されること" do
        expect do
          post like_path(micropost_id: micropost.id), params: { create: like }, xhr: true
        end.to change(Like, :count).by(1)
      end
    end
  end

  describe "DELETE #destroy" do
    it "リクエストが成功すること" do
      delete unlike_path(micropost_id: micropost2.id), params: { micropost_id: micropost2.id }, xhr: true
      expect(response.status).to eq 200
    end

    it "お気に入り解除できること" do
      expect { delete unlike_path(micropost_id: micropost2.id), params: { micropost_id: micropost2.id }, xhr: true }.to change(Like, :count).by(-1)
    end
  end
end
