class AddProjectTypeToWorksAndPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :project_type, :string
    add_column :works, :project_type, :string
  end
end
