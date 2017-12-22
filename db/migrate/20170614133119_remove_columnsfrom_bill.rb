class RemoveColumnsfromBill < ActiveRecord::Migration[5.0]
  def change
  	remove_column :bills, :new
  	remove_column :bills, :bill_id
  	remove_column :bills, :ip_address
  	remove_column :bills, :first_name
  	remove_column :bills, :last_name
  	remove_column :bills, :card_type
  	remove_column :bills, :card_expires_on
  end
end

