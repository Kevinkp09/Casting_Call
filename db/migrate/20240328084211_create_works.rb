class CreateWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :works do |t|
      t.string :project_name
      t.string :artist_role
      t.date :year
      t.string :youtube_link
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
