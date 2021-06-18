class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :total_paid_amount, null: false
      t.integer :security_price, null: false
      t.integer :total_price, null: false
      t.string :currency, null: false
      t.integer :creator_id, null: false
      t.integer :guest_id, null: false
      t.integer :reservation_id, null: false

      t.foreign_key :users, column: :creator_id
      t.foreign_key :guests, column: :guest_id
      t.foreign_key :reservations, column: :reservation_id

      t.timestamps
    end
  end
end
