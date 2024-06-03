class RemoveColumFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :project_name
    remove_column :users, :artist_role
    remove_column :users, :year
    remove_column :users, :youtube_link
  end
end
