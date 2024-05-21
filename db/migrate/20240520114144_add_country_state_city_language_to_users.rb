class AddCountryStateCityLanguageToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :country, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :language, :string
  end
end
