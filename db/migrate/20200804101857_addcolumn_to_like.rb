class AddcolumnToLike < ActiveRecord::Migration[6.0]
  def change
      add_column :likes, :user_id, :string
  end
end
