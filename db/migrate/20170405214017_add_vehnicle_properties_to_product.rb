class AddVehniclePropertiesToProduct < ActiveRecord::Migration[5.0]
  def change
	add_column :products, :title, :string
	add_column :products, :description, :text
	add_column :products, :city, :string
	add_column :products, :state, :string
	add_column :products, :zipcode, :string
	add_column :products, :latitude, :float
	add_column :products, :longitude, :float
	add_column :products, :year, :string
	add_column :products, :miles, :string
	add_column :products, :transmission, :string
	add_column :products, :color, :string
	add_column :products, :cylinder, :string
	add_column :products, :fuel, :string
	add_column :products, :drive, :string
	add_column :products, :address, :string
	add_column :products, :newused, :string
	add_column :products, :vin, :string
	add_column :products, :stocknumber, :string
	add_column :products, :model, :string
	add_column :products, :trim, :string
	add_column :products, :enginedescription, :string
	add_column :products, :interiorcolor, :string
	add_column :products, :options, :string	
  end
end
        