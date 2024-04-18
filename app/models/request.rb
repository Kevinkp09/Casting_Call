class Request < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :package, optional: true
  enum status: {waiting: 0, shortlisted: 1, rejected: 2}
end
