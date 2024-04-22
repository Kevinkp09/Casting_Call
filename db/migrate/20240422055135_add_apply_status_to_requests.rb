class AddApplyStatusToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :apply_status, :integer, default: 0
  end
end
