require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let!(:user1) { create :user1 }
  let!(:user3) { create :user3 }

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get signup_url
      expect(response.status).to eq 200
    end
  end

  describe 'GET #show' do
    it 'リクエストが成功すること' do
      get user_url user1.id
      expect(response.status).to eq 200
    end

    it 'ユーザー名が表示されていること' do
      get user_url user1.id
      expect(response.body).to include "test1"
    end

    context 'ユーザーが存在しない場合' do
      it '404エラー' do
        get user_url 0o0
        expect(response.body).to include "ActiveRecord::RecordNotFound"
      end
    end
  end

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post users_url, params: { user: attributes_for(:user2) }
        expect(response.status).to eq 302
      end

      it 'ユーザーが登録されること' do
        expect do
          post users_url, params: { user: attributes_for(:user2) }
        end.to change(User, :count).by(1)
      end

      it 'リダイレクトすること' do
        post users_url, params: { user: attributes_for(:user2) }
        expect(response).to redirect_to root_url
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post users_url, params: { user: attributes_for(:user1, :invalid) }
        expect(response.status).to eq 200
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post users_url, params: { user: attributes_for(:user1, :invalid) }
        end.not_to change(User, :count)
      end

      it 'エラーが表示されること' do
        post users_url, params: { user: attributes_for(:user1, :invalid) }
        expect(response.body).to include "User nameは15文字以内で入力してください"
      end
    end
  end

  describe 'GET #edit' do
    before do
      sign_in user1
    end

    it 'リクエストが成功すること' do
      get edit_user_url user1
      expect(response.status).to eq 200
    end

    it 'ユーザー名が表示されていること' do
      get edit_user_url user1
      expect(response.body).to include "test1"
    end

    it 'メールアドレスが表示されていること' do
      get edit_user_url user1
      expect(response.body).to include "test0@example.co.jp"
    end
  end

  describe 'PUT #update' do
    before do
      sign_in user1
    end

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        patch user_url user1, params: { user: attributes_for(:user2) }
        expect(response.status).to eq 302
      end

      it 'ユーザー名が更新されること' do
        expect do
          patch user_url user1, params: { user: attributes_for(:user2) }
        end.to change { User.find(user1.id).user_name }.from('test1').to('test2')
      end

      it 'リダイレクトすること' do
        patch user_url user1, params: { user: attributes_for(:user2) }
        expect(response).to redirect_to user_url user1
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        patch user_url user1, params: { user: attributes_for(:user1, :invalid) }
        expect(response.status).to eq 200
      end

      it 'ユーザー名が変更されないこと' do
        expect do
          patch user_url user1, params: { user: attributes_for(:user1, :invalid) }
        end.not_to change(User.find(user1.id), :user_name)
      end

      it 'エラーが表示されること' do
        patch user_url user1, params: { user: attributes_for(:user1, :invalid) }
        expect(response.body).to include 'User nameは15文字以内で入力してください'
        # end
      end
    end
  end

  describe 'PUT #password_update' do
    before do
      sign_in user1
    end

    let!(:password_params) do
      {
        password: 'newpassword',
        password_confirmation: 'newpassword',
        current_password: user1.password,
      }
    end
    let!(:password_params_mismatch) do
      {
        password: 'newpassword',
        password_confirmation: 'currentpassword',
        current_password: user1.password,
      }
    end

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put password_update_url user1, params: { user: password_params }
        expect(response.status).to eq 302
      end

      it 'パスワードが更新されること' do
        put password_update_url user1, params: { user: password_params }
        expect(flash[:success]).to match('パスワードを変更しました')
      end

      it 'リダイレクトすること' do
        put password_update_url user1, params: { user: password_params }
        expect(response).to redirect_to user_url user1
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put password_update_url user1, params: { user: password_params_mismatch }
        expect(response.status).to eq 200
      end

      it 'ユーザー名が変更されないこと' do
        expect do
          put password_update_url user1, params: { user: password_params_mismatch }
        end.not_to change(User.find(user1.id), :user_name)
      end

      it 'エラーが表示されること' do
        put password_update_url user1, params: { user: password_params_mismatch }
        expect(flash[:danger]).to match('新しいパスワードが一致しません')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in user1
    end

    it 'リクエストが成功すること' do
      delete user_url(user1)
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete user_url(user1)
      end.to change(User, :count).by(-1)
    end

    it 'home画面にリダイレクトすること' do
      delete user_url(user1)
      expect(response).to redirect_to(root_path)
    end
  end
end
