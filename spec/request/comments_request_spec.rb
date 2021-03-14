require 'rails_helper'
RSpec.describe CommentsController, type: :request do
  let!(:user1) { create :user1 }
  let!(:user2) { create :user2 }
  let!(:micropost) { create :micropost, user: user2 }

  before do
    sign_in user1
  end

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      let(:comment) { create :comment, user_id: user1.id, micropost_id: micropost.id }

      it 'リクエストが成功すること' do
        post micropost_comments_url micropost, params: { comment: attributes_for(:comment) }
        expect(response.status).to eq 302
      end

      it 'コメントが登録されること' do
        expect do
          post micropost_comments_url micropost, params: { comment: attributes_for(:comment) }
        end.to change(Comment, :count).by(1)
      end

      it 'リダイレクトすること' do
        post micropost_comments_url micropost, params: { comment: attributes_for(:comment) }
        expect(response).to redirect_to micropost_url micropost
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post micropost_comments_url micropost, params: { comment: attributes_for(:comment, :invalid) }
        expect(response.status).to eq 302
      end

      it 'コメントが登録されないこと' do
        expect do
          post micropost_comments_url micropost, params: { comment: attributes_for(:comment, :invalid) }
        end.not_to change(Comment, :count)
      end

      it 'エラーが表示されること' do
        post micropost_comments_url micropost, params: { comment: attributes_for(:comment, :invalid) }
        expect(flash[:danger]).to match "コメントに失敗しました"
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create :comment, user_id: user1.id, micropost_id: micropost.id }

    it 'リクエストが成功すること' do
      delete micropost_comment_url(micropost_id: micropost.id, id: comment.id), params: { comment: comment }
      expect(response.status).to eq 302
    end

    it 'コメントが削除されること' do
      expect do
        delete micropost_comment_url(micropost_id: micropost.id, id: comment.id)
      end.to change(Comment, :count).by(-1)
    end

    it 'home画面にリダイレクトすること' do
      delete micropost_comment_url(micropost_id: micropost.id, id: comment.id), params: { comment: comment }
      expect(response).to redirect_to micropost_url micropost
    end
  end
end
