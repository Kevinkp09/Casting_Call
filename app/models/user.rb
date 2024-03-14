class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  VALID_MOBILE_REGEX = /\A\d{10}\z/
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :mobile_no, presence: true, format: { with: VALID_MOBILE_REGEX, message: "Invalid" }
  validates :username, presence: true
  validates :role, presence: true

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
