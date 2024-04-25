class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.integer :ticket_number
      t.string :category
      t.string :status
      t.date :event_date

      t.timestamps
    end
  end
end
