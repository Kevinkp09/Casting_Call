class Api::V1::PaymentsController < ApplicationController
  skip_before_action :doorkeeper_authorize!
  def create
    user = User.find_by(id: payment_params[:agency_id])
    if user.present?
      package = Package.find_by(name: payment_params[:package_name].strip.downcase)
      if package.present?
        amount = package.price.to_i * 100
        razorpay_order = Razorpay::Order.create(amount: amount, currency: 'INR')
        if razorpay_order.present? && razorpay_order.attributes['id'].present?
          payment = Payment.new(
            agency_id: user.id,
            package_id: package.id,
            razorpay_order_id: razorpay_order.attributes['id'],
            status_type: 'pending'
          )
          if payment.save
            render json: {
              message: "Payment is initiated",
              data: {
                payment: payment
              }
            }, status: :created
          else
            render json: {error: payment.errors.full_messages}, status: :unprocessable_entity
          end
        else
          render json: {message: "Failed to create order with razorpay"}, status: :unprocessable_entity
        end
      else
        render json: {error: "Package not present or it is not user's package"}, status: :not_found
        return
      end
    else
      render json: {error: "User not found"}, status: :not_found
      return
    end
  end

  def callback
    order_id = params["order_id"]
    payment_id = params["payment_id"]
    razorpay_order = Razorpay::Order.fetch(order_id)
    if razorpay_order.attributes['status'] == 'paid'
      @payment = Payment.find_by(razorpay_order_id: order_id)
      if @payment.present?
        @payment.update(status_type: 'paid', razorpay_payment_id: payment_id)
        @user = @payment.user
        if @user.present?
          @user.update(package: @payment.package)
          UserMailer.payment_success_email(@user, @payment.package).deliver_later
        else
          render json: {message: "User not found"}, status: :not_found
        end
        render json: {message: "Payment is done successfully", data: {payment: @payment} }, status: :ok
      else
        render json: {message: "Payment not found"}, status: :not_found
      end
    else
      render json: {message: "Payment failed , please try again!!!"}, status: :unprocessable_entity
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:agency_id, :package_name)
  end
end
