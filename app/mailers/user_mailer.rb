class UserMailer < ApplicationMailer
  def send_otp_email(user)
    @user = user
    mail(to: user.email, subject: 'Your OTP for verification')
  end
end
