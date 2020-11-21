class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :part, :string
    add_column :users, :genre, :string
    add_column :users, :artist, :string
    add_column :users, :age, :integer
    add_column :users, :url, :string
  end
end
