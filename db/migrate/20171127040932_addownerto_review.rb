class AddownertoReview < ActiveRecord::Migration[5.0]
  def change
  	add_column :reviews, :owner_id, :integer
  end
end
