class BookingControlJob
  include Sidekiq::Job

  def perform(booking_id)
    Booking.find(booking_id).destroy
  end
end
