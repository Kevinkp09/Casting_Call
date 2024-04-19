class Post < ApplicationRecord
  has_one_attached :script
  has_many :requests
  has_many :users, through: :requests
  belongs_to :agency, class_name: "User", foreign_key: "agency_id"
  enum category: {artist: 0, dancer: 1, singer: 2}
  enum role: {"artist main lead": 0, "supporting role": 1, "jr artist": 2}
  enum audition_type: {"offline": 0, "online": 1}
end
