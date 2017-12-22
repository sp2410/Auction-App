class AddPicturesToProducts < ActiveRecord::Migration[5.0]
  def change
  	add_reference :pictures, :product, foreign_key: {on_delete: :cascade}
  end
end
