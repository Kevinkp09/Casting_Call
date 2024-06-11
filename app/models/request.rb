class Request < ApplicationRecord
  belongs_to :user
  belongs_to :post
  enum status: {waiting: 0, shortlisted: 1, rejected: 2}
  enum apply_status: {apply: 0, applied: 1}
end
