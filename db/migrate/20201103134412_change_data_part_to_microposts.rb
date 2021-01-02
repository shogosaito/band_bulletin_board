class ChangeDataPartToMicroposts < ActiveRecord::Migration[6.0]
  def change
    change_column :microposts, :part, :integer
  end
end
