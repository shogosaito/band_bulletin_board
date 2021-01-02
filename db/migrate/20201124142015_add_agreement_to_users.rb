class AddAgreementToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :agreement, :string
  end
end
