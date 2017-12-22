class AddUserInfo < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :dealer_Name , :string
  	add_column :users, :address , :string
  	add_column :users, :city , :string
  	add_column :users, :state , :string
  	add_column :users, :zip , :string

  	add_column :users, :bond_Number , :string
  	add_column :users, :dealer_Number , :string
  	add_column :users, :reseller_Number , :string

  	add_column :users, :primary_Phone , :string
  	add_column :users, :mobile_Phone_Number , :string
  	add_column :users, :mobile_Phone_Carrier , :string


  end
end
