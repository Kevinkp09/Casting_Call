class AddIsagencyAndAgencyNameToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :agency_name, :string
    add_column :users, :is_agency, :integer, default: 0
  end
end
