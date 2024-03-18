class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         VALID_MOBILE_REGEX = /\A\d{10}\z/
         VALID_LINK_REGEX = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*)/
  has_one_attached :profile_photo
  has_many_attached :audition_posts
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :mobile_no, presence: true, format: { with: VALID_MOBILE_REGEX, message: "Invalid" }
  validates :username, presence: true
  validates :role, presence: true
  validates :youtube_link, presence: true, format: { with: VALID_LINK_REGEX, message: "Invalid url" }

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
