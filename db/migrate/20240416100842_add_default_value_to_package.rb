class AddDefaultValueToPackage < ActiveRecord::Migration[7.1]
  def change
    change_column :packages, :name, :integer, default: "starter", using: "name::integer"
  end
end
