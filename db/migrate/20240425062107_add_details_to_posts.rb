class AddDetailsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :skin_color, :integer, default: 0
    add_column :posts, :height, :decimal, precision: 5, scale: 2
    add_column :posts, :weight, :decimal, precision: 5, scale: 2
  end
end
