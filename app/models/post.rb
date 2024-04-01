class Post < ApplicationRecord
  belongs_to :user
  enum category: {artist: 0, dancer: 1, singer: 2}
  enum role: {artist_main_lead: 0, supporting_role: 1, jr_artist: 2}
end
