class ChangeDataContentTypeToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :content_type, :string
  end
end
