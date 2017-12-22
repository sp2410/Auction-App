class Addbilltotransaction < ActiveRecord::Migration[5.0]
  def change
  	add_reference :transactions, :bill, foreign_key: {on_delete: :cascade}
  end
end
