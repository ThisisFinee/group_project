require 'securerandom'
require "net/http"
require "uri"
require "typhoeus"
class BookingController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :cancel, :delete]
    def create
        check_tickets_availability(params[:category], params[:date])
    end

    def check_tickets_availability(category, date)
        
        uri = 'http://ticket_server:3000/tickets/free?'
        response = Typhoeus.get(uri + "category=#{category}&event_date=#{date}")
    
        if response.code == 200

            response_hash = JSON.parse(response.body)
            booking_number = SecureRandom.random_number(1_000_000_000)
            status = 'booking'
            price = response_hash['price']
            ticket_number = response_hash['ticket_number']
            booking = Booking.create(booking_number: booking_number, ticket_number: ticket_number, current_price: price)
            
            request = '5min'
            BookingControlJob.perform_in(5.minutes, booking.id, request)

            change_ticket_status(ticket_number, status)
        
            render json: { status: 200, booking_number: booking_number, price: price}, status: :ok
        else
            render json: { error: "Error checking ticket availability" }, status: :unprocessable_entity
        end
    end

    def cancel
        booking_number = params[:booking_number].to_i
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

    def change_ticket_status(ticket_number, status)
        uri = 'http://ticket_server:3000/tickets/status?'
        # Выполнение GET-запроса сервису билетов для проверки доступности билетов
        response = Typhoeus.put(uri + "ticket_number=#{ticket_number}&status=#{status}")
        if response.code != 200
            false
        end
        true
    end 

    def delete
        booking_number = params[:booking_number].to_i
        booking = Booking.find_by(booking_number: booking_number)
        request = 'now'
        BookingControlJob.perform_async(booking.id, request)
        render json: { status: 200 }, status: :ok
    end

    private
    
    def cancel_booking(booking_number)
        booking = Booking.find_by(booking_number: booking_number)
        if booking
            booking_id = booking.id

            status = 'free'

            # Удаляем запись из БД
            request = 'nothing'
            BookingControlJob.perform_async(booking_id, request)

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
