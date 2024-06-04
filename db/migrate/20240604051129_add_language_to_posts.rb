class AddLanguageToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :language, :string
  end
end
