class AddGenreToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :genre, :string
  end
end
