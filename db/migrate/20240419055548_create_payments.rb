class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.integer :agency_id
      t.integer :package_id
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.string :status_type
      t.timestamps
    end
  end
end
