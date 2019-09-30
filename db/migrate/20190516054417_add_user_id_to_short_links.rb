class AddUserIdToShortLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :short_links, :user_id, :integer, null: false
  end
end
