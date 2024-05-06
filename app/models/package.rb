class Package < ApplicationRecord
  enum name: {starter: 0, basic: 1, advance: 2}
  has_many :users
  has_many :payments
end
