require 'razorpay/order'
require 'razorpay/customer'
key_id = "rzp_test_sF4v8bweGRs5TH"
secret_key = "enSJeMH7D6odT88sZIDciGvL"
Rails.logger.info "RAZORPAY_KEY_ID: #{ENV['RAZORPAY_KEY_ID']}"
Rails.logger.info "RAZORPAY_SECRET_KEY: #{ENV['RAZORPAY_SECRET_KEY']}"
Razorpay.setup(key_id, secret_key)
