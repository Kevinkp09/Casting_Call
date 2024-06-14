class Work < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  VALID_LINK_REGEX = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*)/
  validates :youtube_link, format: { with: VALID_LINK_REGEX, message: "Invalid" }
  has_many :performancess, dependent: :destroy
end
