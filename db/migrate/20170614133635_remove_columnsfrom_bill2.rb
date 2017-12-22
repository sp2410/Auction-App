class RemoveColumnsfromBill2 < ActiveRecord::Migration[5.0]
  def change
  	remove_column :bills, :billing_full_name
	remove_column :bills, :city
	remove_column :bills, :state
	remove_column :bills, :country
	remove_column :bills, :zip
  end
end
