class AddFouroreImagesForProducts < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :imagefront, :string
  	add_column :products, :imageback, :string
  	add_column :products, :imageleft, :string
  	add_column :products, :imageright, :string
  end
end

