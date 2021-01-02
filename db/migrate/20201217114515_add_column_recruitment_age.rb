class AddColumnRecruitmentAge < ActiveRecord::Migration[6.0]
  def up
   add_column :microposts, :recruitment_max_age, :string
   add_column :microposts, :recruitment_min_age, :string
 end
 def down
    remove_column :microposts, :recruitment_age, :string
  end
end
