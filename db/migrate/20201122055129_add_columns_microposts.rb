class AddColumnsMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :activity_day, :string
    add_column :microposts, :activity_direction, :string
    add_column :microposts, :music_type, :string
  end
end
