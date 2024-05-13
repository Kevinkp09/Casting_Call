class ChangePriceToPackages < ActiveRecord::Migration[7.1]
  def change
    change_column :packages, :price, :string
  end
end
