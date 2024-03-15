class AddPersonalDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :gender, :string
    add_column :users, :category, :string
    add_column :users, :birth_date, :date
    add_column :users, :current_location, :string
  end
end
