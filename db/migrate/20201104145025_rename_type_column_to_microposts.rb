class RenameTypeColumnToMicroposts < ActiveRecord::Migration[6.0]
  def change
    rename_column :microposts, :type, :content_type
  end
end
