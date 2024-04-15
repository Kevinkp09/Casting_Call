class Package < ApplicationRecord
  belongs_to :agency, class_name: "User", foreign_key: "agency_id"
end
