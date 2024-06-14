class Performance < ApplicationRecord
  belongs_to :work, foreign_key: "work_id", optional: true
end
