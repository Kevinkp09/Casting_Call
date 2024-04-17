class AddDefaultValueToPackage < ActiveRecord::Migration[7.1]
  def change
    change_column :packages, :name, :integer, default: "starter"
  end
end
