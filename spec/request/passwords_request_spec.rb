require 'rails_helper'

RSpec.describe PasswordsController, type: :request do
  let!(:user1) { create :user1 }
  let!(:password_params) do
    {
      password: 'newpassword',
      password_confirmation: 'newpassword',
      current_password: 'test01',
    }
  end
  let!(:password_params_mismatch) do
    {
      password: 'newpassword',
      password_confirmation: 'currentpassword',
      current_password: 'test01',
    }
  end

  before do
    sign_in user1
  end

  describe 'GET #edit' do
    # let!(:password) { create :password }
    it 'リクエストが成功すること' do
      get edit_password_url user1
      expect(response.status).to eq 200
    end

    it 'editテンプレートで表示されること' do
      get edit_password_url user1
      expect(response.body).to include "変更後のパスワード"
      expect(response.body).to include "変更後のパスワード(確認)"
      expect(response.body).to include "現在のパスワード"
    end
  end

  describe 'PUT #update' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put password_url user1, params: password_params
        binding.pry
        expect(response.status).to eq 200
      end

      it 'パスワードが更新されること' do
        expect do
          put password_url user1, params: password_params
        end.to change(user1, :password).from('test01').to('newpassword')
      end
      it 'リダイレクトすること' do
        expect do
          patch password_url user1, params: password_params
          binding.pry
          expect(response).to redirect_to edit_user_url
        end
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put password_url user1, params: password_params_mismatch
        binding.pry
        expect(response.status).to eq 302
      end

      it 'パスワードが変更されないこと' do
        expect do
          put password_url user1, params: password_params_mismatch
        end.not_to change(User.find(user1.id), :password)
      end

      it 'エラーが表示されること' do
        put password_url user1, params: password_params_mismatch
        expect(response.body).to include 'Password confirmationとPasswordの入力が一致しません'
      end
    end
  end
end
