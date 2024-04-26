class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :ticket_number
      t.string :name
      t.integer :age
      t.string :document_number
      t.string :document_type

      t.timestamps
    end
  end
end
