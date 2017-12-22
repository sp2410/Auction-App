class RemoveColumnsfromBill3 < ActiveRecord::Migration[5.0]
  def change
  	remove_column :bills, :billing_street_address
  end
end
