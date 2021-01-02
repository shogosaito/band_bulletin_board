class AddColumnActivationToken < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :activation_digest, :string
  end
end
