class DropWork < ActiveRecord::Migration[7.1]
  def change
    drop_table :works
  end
end
