class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.string :status, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.integer :nights, null: false
      t.integer :total_guest, null: false
      t.integer :adult_guest, null: false
      t.integer :children_guest, null: false
      t.integer :infant_guest, null: false
      t.integer :creator_id, null: false
      t.integer :guest_id, null: false

      t.foreign_key :users, column: :creator_id
      t.foreign_key :guests, column: :guest_id

      t.timestamps
    end
  end
end
