class AddPostIdToRequests < ActiveRecord::Migration[7.1]
  def change
    add_reference :requests, :post, null: false, foreign_key: true
  end
end
