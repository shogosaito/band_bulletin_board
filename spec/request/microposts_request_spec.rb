require 'rails_helper'

RSpec.describe MicropostsController, type: :request do
  let(:user1) { create :user1 }
  let!(:prefecture) { create :prefecture }
  let!(:micropost) { create :micropost, user_id: user1.id }

  before do
    sign_in user1
  end

  describe 'GET #index' do
    it 'リクエストが成功すること' do
      get micropost_url micropost
      expect(response.status).to eq 200
    end

    it 'タイトルとジャンルが表示されていること' do
      get micropost_url micropost
      expect(response.body).to include "test1"
      expect(response.body).to include "J-POP,アニメ"
    end
  end

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get new_url
      expect(response.status).to eq 200
    end
  end

  describe 'GET #show' do
    it 'リクエストが成功すること' do
      get micropost_url micropost.id
      expect(response.status).to eq 200
    end

    it 'タイトルが表示されていること' do
      get micropost_url micropost.id
      expect(response.body).to include 'test1'
    end

    context 'ユーザーが存在しない場合' do
      it '404エラー' do
        get micropost_url 0o0
        expect(response.body).to include "ActiveRecord::RecordNotFound"
      end
    end
  end

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post microposts_url, params: { micropost: attributes_for(:micropost2) }
        expect(response.status).to eq 302
      end

      it '記事が登録されること' do
        expect do
          post microposts_url, params: { micropost: attributes_for(:micropost2) }
        end.to change(Micropost, :count).by(1)
      end

      it 'リダイレクトすること' do
        post microposts_url, params: { micropost: attributes_for(:micropost2) }
        expect(response).to redirect_to root_url
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post microposts_url, params: { micropost: attributes_for(:micropost, :invalid) }
        expect(response.status).to eq 200
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post microposts_url, params: { micropost: attributes_for(:micropost, :invalid) }
        end.not_to change(Micropost, :count)
      end

      it 'エラーが表示されること' do
        post microposts_url, params: { micropost: attributes_for(:micropost, :invalid) }
        expect(response.body).to include 'タイトルを入力してください。'
      end
    end
  end

  describe 'GET #edit' do
    it 'リクエストが成功すること' do
      get edit_micropost_url micropost
      expect(response.status).to eq 200
    end

    it 'ユーザー名が表示されていること' do
      get edit_micropost_url micropost
      expect(response.body).to include 'test1'
    end

    it 'メールアドレスが表示されていること' do
      get edit_micropost_url micropost
      expect(response.body).to include 'テスト1'
    end
  end

  describe 'PUT #update' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put micropost_url micropost, params: { micropost: attributes_for(:micropost2) }
        expect(response.status).to eq 302
      end

      it 'タイトルが更新されること' do
        expect do
          put micropost_url micropost, params: { micropost: attributes_for(:micropost2) }
        end.to change { Micropost.find(micropost.id).title }.from('test1').to('test2')
      end

      it 'リダイレクトすること' do
        put micropost_url micropost, params: { micropost: attributes_for(:micropost2) }
        expect(response).to redirect_to micropost_url micropost
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put micropost_url micropost, params: { micropost: attributes_for(:micropost, :invalid) }
        expect(response.status).to eq 422
      end

      it 'タイトルが変更されないこと' do
        expect do
          put micropost_url micropost, params: { micropost: attributes_for(:micropost, :invalid) }
        end.not_to change(Micropost.find(micropost.id), :title)
      end

      it 'エラーが表示されること' do
        put micropost_url micropost, params: { micropost: attributes_for(:micropost, :invalid) }
        expect(response.body).to include 'Titleを入力してください'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'リクエストが成功すること' do
      delete micropost_url micropost
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete micropost_url micropost
      end.to change(Micropost, :count).by(-1)
    end

    it 'ユーザー一覧にリダイレクトすること' do
      delete micropost_url micropost
      expect(response).to redirect_to root_url
    end
  end
end
