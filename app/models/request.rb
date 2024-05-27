class Request < ApplicationRecord
  belongs_to :user
  belongs_to :post
  enum status: {waiting: 0, shortlisted: 1, rejected: 2}
  enum apply_status: {apply: 0, applied: 1}
   VALID_LINK_REGEX = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()!@:%_\+.~#?&\/\/=]*)/
  validates :link, format: { with: VALID_LINK_REGEX, message: "Invalid" }
end
