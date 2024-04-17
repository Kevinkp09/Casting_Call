class AddPackageIdToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :package_id, :integer
    remove_column :packages, :agency_id
  end
end
