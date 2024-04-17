class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  enum role: {artist: 0, agency: 1, admin: 2}
  enum approval_status: {pending: 0, approved: 1, rejected: 2}
         VALID_MOBILE_REGEX = /\A\d{10}\z/
  has_one_attached :profile_photo
  belongs_to :package, class_name: "Package", foreign_key: "package_id"
  has_many :works
  has_many :requests
  has_many :posts, through: :requests
  has_many :posts, foreign_key: 'agency_id'
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :mobile_no, presence: true, format: { with: VALID_MOBILE_REGEX, message: "Invalid" }
  validates :username, presence: true
  validates :role, presence: true
  after_create :generate_otp

   def generate_otp
      self.otp = rand.to_s[2..5]
      self.save!
      UserMailer.send_otp_email(self).deliver_now
   end

   def self.authenticate(email, password)
      user = User.find_for_authentication(email: email)
      user&.valid_password?(password) ? user : nil
   end

   def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
         user.email = auth.info.email
         user.password = auth.info.password
      end
   end
end
