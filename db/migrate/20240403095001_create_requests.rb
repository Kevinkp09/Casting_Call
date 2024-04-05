class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.integer :status

      t.timestamps
    end
  end
end
