class RemoveVerifiedUserFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :verified_user
  end
end
