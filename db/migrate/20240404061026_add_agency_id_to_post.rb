class AddAgencyIdToPost < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :agency_id, :integer
  end
end
