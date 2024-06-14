class AddUserIdAndRemoveWorkIdFromPerformances < ActiveRecord::Migration[7.1]
  def change
    add_column :performances, :user_id, :bigint
    remove_column :performances, :work_id
  end
end
