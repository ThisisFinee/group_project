require 'securerandom'
require "net/http"
require "uri"
require "typhoeus"
class BookingController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :cancel]
    def create
        
        # Пример запроса
        # http://localhost:3000/booking?category=vip&date=2024-01-01


        # Логика создания бронирования на основе параметров запроса
        category = params[:category]
        date = params[:date]
        # Дополнительная логика, например, создание объекта Booking и сохранение в базе данных
        
        # Отправка ответа в формате JSON
        check_tickets_availability(params[:category], params[:date])
    end

    def check_tickets_availability(category, date)
        # Получение параметров запроса для билетов
        # category = params[:category]
        # date = params[:date]
        status = "free"
        uri = 'http://ticket_server:3000/tickets/free?'
        # Выполнение GET-запроса сервису билетов для проверки доступности билетов
        response = Typhoeus.get(uri + "category=#{category}&event_date=#{date}")
        puts response.body
        if response.code == 200
            response_hash = JSON.parse(response.body)
            # Обработка данных из response_hash
        # Временная заглушка

        # response_hash = {
        #     'ticket_number': 123,
        #     "price": 100,
        #     "status": 200
        # }
        # Обработка ответа

            # Если запрос выполнен успешно, получаем данные о свободных билетах из ответа
            
        # Сучайная генерация 128 битного числа
            booking_number = SecureRandom.random_number(1_000_000_000)
            status = 'booking'
            price = response_hash[:price]
            ticket_number = response_hash[:ticket_number]
            # Тут должен начинаться Sidekiq и должна произойти запись в БД
            puts booking_number
            booking = Booking.create(booking_number: booking_number, ticket_number: ticket_number, current_price: price)

            # НА ДЕБАГЕ СТОИТ 1 минута нужно будет поменять на 5

            BookingControlJob.perform_in(5.minutes, booking.id)



            # Изменение статуса билета
            puts "Изменили статус"
            # change_ticket_status(ticket_number, status)
        
            render json: { status: 200, booking_number: booking_number, price: price}, status: :ok
        else
            render json: { error: "Error checking ticket availability" }, status: :unprocessable_entity
        end
    end

    def cancel
        booking_number = params[:booking_number].to_i
        
        puts "ЗАПРОС на удаление брони"
        # Отменить бронирование и удалить его из Sidekiq и БД
        if cancel_booking(booking_number)
          render json: { status: 200 }
        else
          render json: { error: 'Failed to cancel booking' }, status: :unprocessable_entity
        end
    end

    def show
        # Получение параметра запроса с номером бронирования
        booking_number = params[:booking_number]
    
        # Поиск бронирования по номеру
        booking = Booking.find_by(booking_number: booking_number)
    
        if booking.present?
          # Если бронь найдена, возвращаем информацию о билете
          render json: { status: 200, ticket_number: booking.ticket_number, price: booking.current_price }, status: :ok
        else
          # Если бронь не найдена, возвращаем ошибку
          render json: { error: "Booking not found" }, status: :not_found
        end
     end
    private

    def change_ticket_status(ticket_number, status)
        HTTParty.put("http://your_app_url/tickets/status?ticket_number=#{ticket_number}&status=#{status}")
    end

    def cancel_booking(booking_number)
        booking = Booking.find_by(booking_number: booking_number)
        if booking
            booking_id = booking.id

            puts booking.ticket_number
            status = 'free'
            # Меняем значение колонки booking в БД Tickets на значение в свободен

            #change_ticket_status(booking.ticket_number, status)
            # change_ticket_status(booking.ticket_number, status)
            # Удаляем запись из БД
            
            BookingControlJob.perform_async(booking_id)

            # Удаляем из очереди на удаление
            stop_sidekiq_task(booking_id)
            return true
        end
        false
    end

    # http://localhost:3000/booking/cancel?booking_number=0
    def stop_sidekiq_task(booking_id)
        # Ищем задачу Sidekiq по booking_id
        queue = Sidekiq::ScheduledSet.new
        flag = false
        queue.each do |job|
            if job.args.first == booking_id
                job.delete
                flag = true
            end
        end
        flag
    end
end
