class ChangeColumnOtpUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :otp, :string
  end
end
