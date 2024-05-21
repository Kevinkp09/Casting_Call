class AddBankDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :account_no, :string
    add_column :users, :branch_name, :string
    add_column :users, :pan_no, :string
    add_column :users, :gst_no, :string
  end
end
