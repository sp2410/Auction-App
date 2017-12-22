class AddStageToProduct < ActiveRecord::Migration[5.0]
  def change
  	add_column :products, :stage, :string, :default => "never_auctioned"
  end
end
