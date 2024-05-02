class UserMailer < ApplicationMailer
  def send_otp_email(user)
    @user = user
    mail(to: user.email, subject: 'Your OTP for verification')
  end

  def forgot_password_email(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: "Forgot Password OTP")
  end
end
