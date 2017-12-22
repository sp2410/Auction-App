class AddinginteriorImages < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :frontinterior, :string
  	add_column :products, :rearinterior, :string
  end
end

