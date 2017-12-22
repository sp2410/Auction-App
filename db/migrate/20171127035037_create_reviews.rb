class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.boolean :approved, default: false
      t.references :user, foreign_key: true
      t.string :comment
      t.integer :rating

      t.timestamps
    end
  end
end
