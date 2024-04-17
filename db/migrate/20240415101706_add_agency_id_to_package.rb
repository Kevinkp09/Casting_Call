class AddAgencyIdToPackage < ActiveRecord::Migration[7.1]
  def change
    add_column :packages, :agency_id, :integer
  end
end
