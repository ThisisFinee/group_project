class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.integer :booking_number
      t.integer :ticket_number
      t.integer :current_price

      t.timestamps
    end
  end
end
