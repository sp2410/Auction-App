class Addwarrantytouser < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :warranty , :string
  end
end
