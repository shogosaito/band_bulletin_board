class AddColumnGender < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :gender, :string
  end
end
