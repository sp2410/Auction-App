class AddproxyidtoaAuction < ActiveRecord::Migration[5.0]
  def change
  	add_column :auctions, :proxybid , :integer, :default => 0	
  end
end
