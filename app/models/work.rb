class Work < ApplicationRecord
  belongs_to :user
  VALID_LINK_REGEX = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*)/
  validates :youtube_link, format: { with: VALID_LINK_REGEX, message: "Invalid" }
end
