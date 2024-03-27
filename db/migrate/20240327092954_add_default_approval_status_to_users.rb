class AddDefaultApprovalStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :approval_status, :integer, default: 0
  end
end
