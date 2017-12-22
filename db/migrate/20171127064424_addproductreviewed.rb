class Addproductreviewed < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :reviewed, :boolean, :default => false
  end
end
