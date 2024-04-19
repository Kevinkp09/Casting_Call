class AddAuditionTypeToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :audition_type, :integer, default: 0
  end
end
