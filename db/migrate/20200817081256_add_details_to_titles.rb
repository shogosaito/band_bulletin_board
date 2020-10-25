class AddDetailsToTitles < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :fullname, :string
    remove_column :users, :username, :string
    remove_column :users, :name, :string
  end
end
