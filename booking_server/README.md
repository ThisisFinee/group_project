# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

Запрос на бронирование билета
http://localhost:3000/booking?category=vip&date=2024-01-01

Запрос на отмену брони билета с конкретной бронью
http://localhost:3000/booking/cancel?booking_number=37603587

Запрос на получение конкретной брони в БД
http://localhost:3000/booking/show?booking_number=37603587
