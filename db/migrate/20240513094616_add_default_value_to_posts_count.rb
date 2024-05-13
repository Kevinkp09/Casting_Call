class AddDefaultValueToPostsCount < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :posts_count, :integer, default: 0
  end
end
