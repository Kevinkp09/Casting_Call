class CreatePerformances < ActiveRecord::Migration[7.1]
  def change
    create_table :performances do |t|
      t.string :video_link
      t.string :audition_link
      t.bigint :work_id
      t.timestamps
    end
  end
end
