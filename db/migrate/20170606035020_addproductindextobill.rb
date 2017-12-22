class Addproductindextobill < ActiveRecord::Migration[5.0]
  def change
  	add_reference :bills, :product, foreign_key: {on_delete: :cascade}
  end
end
