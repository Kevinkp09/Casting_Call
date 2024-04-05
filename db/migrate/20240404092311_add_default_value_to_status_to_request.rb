class AddDefaultValueToStatusToRequest < ActiveRecord::Migration[7.1]
  def change
    change_column :requests, :status, :integer, default: 0
  end
end
