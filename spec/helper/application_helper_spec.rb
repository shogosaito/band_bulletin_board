# require 'rails_helper'
#
# RSpec.describe ApplicationHelper, type: :helper do
#   describe "#full_title" do
#     context "page_title is empty" do
#       it "removes symbol" do
#         expect(helper.full_title).to eq('BIGBAG Store')
#       end
#     end
#
#     context "page_title is not empty" do
#       it "returns title and application name where contains symbol" do
#         expect(helper.full_title('RUBY ON RAILS TOTE')).to eq('RUBY ON RAILS TOTE - BIGBAG Store')
#       end
#     end
#
#     context "page_title is nil" do
#       it "returns title and application name where contains symbol" do
#         expect(helper.full_title(nil)).to eq('BIGBAG Store')
#       end
#     end
#
#     context "page_title is blank" do
#       it "returns title and application name where contains symbol" do
#         expect(helper.full_title("")).to eq('BIGBAG Store')
#       end
#     end
#   end
# end
