# group project

version: '3'
services:
  user_server:
    build: user_extend_service
    command: rails s -b 0.0.0.0
    volumes:
      - ./user_extend_service:/usr/src
    ports:
      - 3000:3000
    depends_on:
      - db
  db:
    image: postgres:11.5
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres:/var/lib/postgresql/data
  purchase_server:
    build: purchase_extend_service/
    volumes:
      - ./purchase_extend_service:/usr/src
    ports:
      - "3002:3000"
    environment:
      - USER_FIND_SERVICE_LINK=http://user_server:3000/find?
      - USER_SERVICE_LINK=http://user_server:3000/users?
      - BOOKING_SERVICE_LINK=http://booking_server:3000/booking/show?
      - SIDEKIQ_SERVICE_LINK=http://booking_server:3000/booking/cancel?
      - TICKET_STATUS_SERVICE_LINK=http://ticket_server:3000/tickets/status?
    command: ruby sinatra_purchase.rb

volumes:
  postgres:


