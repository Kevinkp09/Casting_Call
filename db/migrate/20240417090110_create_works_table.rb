class CreateWorksTable < ActiveRecord::Migration[7.1]
  def change
    create_table :works do |t|
      t.string "project_name"
      t.string "artist_role"
      t.date "year"
      t.string "youtube_link"
      t.integer "user_id", null: false
      t.index ["user_id"], name: "index_works_on_user_id"
      t.timestamps
    end
  end
end
