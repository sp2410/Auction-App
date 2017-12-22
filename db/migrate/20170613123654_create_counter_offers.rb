class CreateCounterOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :counter_offers do |t|
      t.integer :value
      t.integer :winner_id
      t.boolean :accepted_status, :default => false

      t.timestamps
    end
  end
end
