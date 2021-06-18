class CreateGuests < ActiveRecord::Migration[5.2]
  def change
    create_table :guests do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone_number, null: false
      t.string :external_id, null: false
      t.integer :creator_id, null: false

      t.foreign_key :users, column: :creator_id
      t.timestamps null: false
    end
  end
end
