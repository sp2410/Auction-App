class AddbilledToProduct < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :billed, :boolean, :default => false
  end
end

