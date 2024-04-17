class Package < ApplicationRecord
  enum name: {starter: 0, basic: 1, advance: 2}
  belongs_to :agency, class_name: "User", foreign_key: "agency_id"
  belongs_to :post
  has_many :requests
end
