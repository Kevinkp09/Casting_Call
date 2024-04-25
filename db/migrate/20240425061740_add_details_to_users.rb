class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :skin_color, :integer, default: 0
    add_column :users, :height, :decimal, precision: 5, scale: 2
    add_column :users, :weight, :decimal, precision: 5, scale: 2
  end
end
