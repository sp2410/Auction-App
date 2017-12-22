class AddOriginaluserToProducts < ActiveRecord::Migration[5.0]
  def change
  	# add_reference :products, :originaluser, index: true
  	add_column :products, :originaluser_id, :integer
  end
end
