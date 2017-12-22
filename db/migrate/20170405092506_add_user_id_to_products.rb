class AddUserIdToProducts < ActiveRecord::Migration[5.0]
  def change
  	add_reference :products, :user, foreign_key: {on_delete: :cascade}
  end
end
