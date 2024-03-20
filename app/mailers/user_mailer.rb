class UserMailer < ApplicationMailer
  def send_otp_email(email, otp)
      @otp = otp
      @email = email
      mail(to: email, subject: 'Your OTP for verification')
  end
end
