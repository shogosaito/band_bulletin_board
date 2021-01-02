class ChangeDataContentTypeToMicroposts < ActiveRecord::Migration[6.0]
  def change
    change_column :microposts, :content_type, :string
  end
end
