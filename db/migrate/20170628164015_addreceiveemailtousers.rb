class Addreceiveemailtousers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :receiveemail, :boolean, :default => false
  end
end
