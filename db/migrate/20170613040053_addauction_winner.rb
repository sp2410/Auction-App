class AddauctionWinner < ActiveRecord::Migration[5.0]
  def change
  	add_column :auctions, :winner_id, :integer
  end
end
