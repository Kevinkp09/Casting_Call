class Payment < ApplicationRecord
  belongs_to :agency, class_name: "User", foreign_key: "agency_id"
  belongs_to :package, class_name: "Package", foreign_key: "package_id"
end
