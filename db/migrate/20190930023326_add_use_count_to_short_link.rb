class AddUseCountToShortLink < ActiveRecord::Migration[5.2]
  def change
    add_column :short_links, :use_count, :integer
  end
end
