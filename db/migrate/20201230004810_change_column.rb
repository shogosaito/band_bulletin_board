class ChangeColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :microposts, :part, :string
  end
end
