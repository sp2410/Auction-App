class AddReferredByToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :referredby, :string
  end
end
