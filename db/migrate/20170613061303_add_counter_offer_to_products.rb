class AddCounterOfferToProducts < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :sellerselected_option, :integer, :default => 0
  end
end
