class AddDefaultValueToNameToPackage < ActiveRecord::Migration[7.1]
  def change
      change_column :packages, :name, :integer, default: 0
  end
end
