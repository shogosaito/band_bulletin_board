class AddRecruitmentGenderToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :recruitment_age, :string
  end
end
