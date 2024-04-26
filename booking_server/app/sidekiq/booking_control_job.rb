class BookingControlJob
  include Sidekiq::Job

  def perform(booking_id, request)
    
    booking = Booking.find_by(id: booking_id)
    return unless booking

    ticket_num = booking.ticket_number

    # Удаляем бронирование
    booking.destroy

    if request == '5min' or request == 'now'
    # Изменяем статус билета на 'free'
      booking_controller = BookingController.new
      booking_controller.change_ticket_status(ticket_num, 'free')
    end
  end
end