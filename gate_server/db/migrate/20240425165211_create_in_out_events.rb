class CreateInOutEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :in_out_events do |t|
      t.integer :ticket_number
      t.string :user_name
      t.datetime :date_time
      t.string :user_action
      t.boolean :status

      t.timestamps
    end
  end
end
