class AddWorkDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :project_name, :string
    add_column :users, :artist_role, :string
    add_column :users, :year, :date
    add_column :users, :youtube_link, :string
  end
end
