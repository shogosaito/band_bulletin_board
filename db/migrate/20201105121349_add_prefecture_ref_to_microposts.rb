class AddPrefectureRefToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_reference :microposts, :prefecture, foreign_key: true
  end
end
