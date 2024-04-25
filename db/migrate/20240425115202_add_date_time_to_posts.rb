class AddDateTimeToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :date, :date
    add_column :posts, :time, :time
  end
end
