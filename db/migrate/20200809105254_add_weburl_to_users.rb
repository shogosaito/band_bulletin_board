class AddWeburlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :weburl, :string
  end
end
