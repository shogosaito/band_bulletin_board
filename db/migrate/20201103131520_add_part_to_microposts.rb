class AddPartToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :part, :string
  end
end
