class AddGgogleLinkProjectTypeToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :google_link, :string
    
  end
end
