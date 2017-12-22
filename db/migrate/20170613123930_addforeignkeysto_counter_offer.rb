class AddforeignkeystoCounterOffer < ActiveRecord::Migration[5.0]
  def change
  	add_reference :counter_offers, :auction, foreign_key: {on_delete: :cascade}
  	add_column :counter_offers, :owner_id, :integer  	


  end
end

