class AddApprovalStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :approval_status, :integer
  end
end
