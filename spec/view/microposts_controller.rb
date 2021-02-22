# require 'rails_helper'
#
#
# RSpec.describe MicropostsController, type: :controller do
#   describe 'GET #index' do
#     let!(:microposts) { create_list(:micropost, 3) }
#
#     it 'indexテンプレートが表示されること' do
#       get :index
#       expect(response).to render_template :index
#     end
#
#     it '@micropostsが取得できていること' do
#       get :index
#       expect(assigns(:microposts)).to eq microposts
#     end
#
#     it 'リクエストが成功すること' do
#       get :index
#       expect(response.status).to eq 200
#     end
#  end
#
#  describe 'GET #new' do
#      it 'リクエストが成功すること' do
#        get :new
#        expect(response.status).to eq 200
#      end
#
#      it 'newテンプレートで表示されること' do
#        get :new
#        expect(response).to render_template :new
#      end
#
#      it '@userがnewされていること' do
#        get :new
#        expect(assigns :micropost).to_not be_nil
#      end
#    end
#  describe 'GET #show' do
#
#       let(:micropost) { :micropost }
#
#       it 'リクエストが成功すること' do
#         get :show, params: { id: micropost.id }
#         expect(response.status).to eq 200
#       end
#
#       it 'showテンプレートで表示されること' do
#         get :show, params: { id: micropost.id }
#         expect(response).to render_template :show
#       end
#
#       it '@micropostが取得できていること' do
#         get :show, params: { id: micropost.id }
#         expect(assigns :micropost).to eq :micropost
#       end
#     end
#
#     describe 'POST #create' do
#    context 'パラメータが妥当な場合' do
#      it 'リクエストが成功すること' do
#        micropost micropost_url, params: {
#          title:"test", genre[], :content_type, :content, :part, :prefecture_id }
#        expect(response.status).to eq 200
#      end
#
#      it '記事が登録されること' do
#        expect do
#          post micropost_url, params: { user: FactoryBot.attributes_for(:user) }
#        end.to change(Micropost, :count).by(1)
#      end
#
#      it 'リダイレクトすること' do
#        post micropost_url, params: { user: FactoryBot.attributes_for(:user) }
#        expect(response).to redirect_to Micropost.last
#      end
#    end
#
#    context 'パラメータが不正な場合' do
#      it 'リクエストが成功すること' do
#        post micropost_url, params: { user: FactoryBot.attributes_for(:user, :invalid) }
#        expect(response.status).to eq 302
#      end
#
#      it '記事が登録されないこと' do
#        expect do
#          post micropost_url, params: { user: FactoryBot.attributes_for(:user, :invalid) }
#        end.to_not change(Micropost, :count)
#      end
#
#      it 'エラーが表示されること' do
#        post micropost_url, params: { user: FactoryBot.attributes_for(:user, :invalid) }
#        expect(response.body).to include 'prohibited this user from being saved'
#      end
#    end
#  end
# end
