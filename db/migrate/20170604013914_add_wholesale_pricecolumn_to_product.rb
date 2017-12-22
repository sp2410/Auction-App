class AddWholesalePricecolumnToProduct < ActiveRecord::Migration[5.0]
  def change

  	add_column :products, :bluebook, :string
  	add_column :products, :miles_bluebook, :string

  	add_column :products, :runs_condition, :string
  	add_column :products, :drives_condition, :string
  	add_column :products, :tires_condition, :string
  	add_column :products, :paint_condition, :string
  	add_column :products, :windshield_condition, :string
  	add_column :products, :interior_condition, :string

  	add_column :products, :check_engine_light, :string
  	add_column :products, :ABS_light, :string
  	add_column :products, :Airbag_light, :string

  	add_column :products, :check_type, :string

  end
end

