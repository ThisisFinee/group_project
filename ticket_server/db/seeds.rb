# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

event_date = Date.new(2024, 1, 1)

# Создаем билеты для категории "fan"
150.times do |i|
  Ticket.create!(
    ticket_number: i + 1,
    category: 'fan',
    status: 'free',
    event_date: event_date
  )
end

# Создаем билеты для категории "vip"
50.times do |i|
  Ticket.create!(
    ticket_number: i + 151, # Стартовый номер для vip билетов
    category: 'vip',
    status: 'free',
    event_date: event_date
  )
end