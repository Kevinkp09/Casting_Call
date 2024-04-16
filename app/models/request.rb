class Request < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :package
  enum status: {waiting: 0, shortlisted: 1, rejected: 2}
end
