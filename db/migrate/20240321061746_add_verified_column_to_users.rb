class AddVerifiedColumnToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :verified_user, :boolean, default: false
  end
end
