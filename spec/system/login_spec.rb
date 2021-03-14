require "rails_helper"
RSpec.describe 'Users', type: :system do
  before do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config['omniauth.auth'] = set_omniauth :google_oauth2
  end

  let!(:user) { create :user1 }

  it "Google認証できること/新規登録画面" do
    visit signup_path
    click_on 'googleで登録'
    sleep 1
    expect(current_path).to eq root_path
    expect(page).to have_content 'googleアカウントによる認証に成功しました'
  end

  it "Google認証できること/ログイン画面" do
    visit login_path
    click_on 'googleで登録'
    sleep 1
    expect(current_path).to eq root_path
    expect(page).to have_content 'googleアカウントによる認証に成功しました'
  end

  it "Google認証未登録の場合/新規登録画面" do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    visit signup_path
    click_on 'googleで登録'
    sleep 1
    expect(current_path).to eq root_path
    expect(page).to have_content 'SNSログインに失敗しました。'
  end
end
