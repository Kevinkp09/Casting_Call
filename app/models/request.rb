class Request < ApplicationRecord
  belongs_to :user
  belongs_to :post
  enum status: {pending: 0, approved: 1, rejected: 2} 
end
