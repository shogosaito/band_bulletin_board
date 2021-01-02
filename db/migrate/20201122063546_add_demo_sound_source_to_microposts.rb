class AddDemoSoundSourceToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :demo_sound_source, :string
  end
end
