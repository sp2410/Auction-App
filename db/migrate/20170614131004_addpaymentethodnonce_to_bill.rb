class AddpaymentethodnonceToBill < ActiveRecord::Migration[5.0]
  def change
  	add_column :bills, :payment_method_nonce , :string
  end
end
