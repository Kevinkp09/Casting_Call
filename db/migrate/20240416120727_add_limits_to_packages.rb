class AddLimitsToPackages < ActiveRecord::Migration[7.1]
  def change
    add_column :packages, :posts_limit, :integer 
    add_column :packages, :requests_limit, :integer
  end
end
