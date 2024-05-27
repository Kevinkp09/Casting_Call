class AddLinkToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :link, :string
  end
end
