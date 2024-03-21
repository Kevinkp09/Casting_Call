class ChangeRoleColumnUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :role, :integer, default: 0
  end
end
