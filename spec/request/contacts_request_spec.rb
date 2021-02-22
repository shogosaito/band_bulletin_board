require 'rails_helper'

RSpec.describe ContactsController, type: :request do
  let!(:user1) { create :user1 }

  before do
    sign_in user1
    $post_user = user1
  end

  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get contact_url
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    let(:contact) { create :contact }

    it 'リクエストが成功すること' do
      post contact_create_url params: { contact: attributes_for(:contact) }
      expect(response.status).to eq 302
    end
  end
end
