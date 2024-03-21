class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: [:artist, :agency, :admin] 
         VALID_MOBILE_REGEX = /\A\d{10}\z/
         VALID_LINK_REGEX = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*)/
  has_one_attached :profile_photo
  has_many_attached :audition_posts
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :mobile_no, presence: true, format: { with: VALID_MOBILE_REGEX, message: "Invalid" }
  validates :username, presence: true
  validates :role, presence: true
  before_create :generate_otp

   def generate_otp
      self.otp = rand.to_s[2..5]
      UserMailer.send_otp_email(self).deliver_now
   end

  def self.authenticate!(email, credential, credential_type)
    user = find_by(email: email)
    if user && user.valid_credential?(credential, credential_type)
      user
    else
      nil
    end
  end

  def valid_credential?(credential, credential_type)
    case credential_type.to_sym
    when :password
      valid_password?(credential)
    when :otp
      self.otp == credential ? true : false
    else
      false
    end
  end
end
