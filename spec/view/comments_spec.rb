# require 'rails_helper'
#
#
# RSpec.describe CommentsController, type: :controller do
#   describe 'Get request' do
#     let!(:taxonomy) { create :taxonomy }
#     let(:taxon) { create :taxon, parent: taxonomy.root }
#     let(:product) { create(:product, taxons: [taxon]) }
#     let(:other_product) { create(:product, taxons: [taxon]) }
#
#     before do
#       get :show, params: { id: taxon.id }
#     end
#
#     it "assigns @products" do
#       expect(assigns(:products)).to eq [product, other_product]
#     end
#
#     it "assigns @taxon" do
#       expect(assigns(:taxon)).to eq taxon
#     end
#
#     it "assigns @taxonomies" do
#       expect(assigns(:taxonomies)).to include(taxonomy)
#     end
#
#     it 'リクエストが成功すること' do
#       expect(response.status).to eq 200
#     end
#
#     it 'showテンプレートが表示されること' do
#       expect(response).to render_template :show
#     end
#   end
# end
