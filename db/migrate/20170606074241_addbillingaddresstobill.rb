class Addbillingaddresstobill < ActiveRecord::Migration[5.0]
  def change
  	add_column :bills, :billing_full_name , :string  	
  	add_column :bills, :billing_street_address , :string  
  	add_column :bills, :city , :string  
  	add_column :bills, :state , :string 
  	add_column :bills, :country , :string   
  	add_column :bills, :zip , :string  
  end
end
