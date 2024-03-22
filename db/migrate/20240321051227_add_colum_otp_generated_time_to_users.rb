class AddColumOtpGeneratedTimeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :otp_generated_time, :datetime
  end
end
