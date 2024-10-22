require './workfiles/checker'
require 'httparty'
require 'uri'
require 'json'

class PurchaseService
  def initialize(params)
    missing_params = Checker.missing_params(params)
    if !missing_params.any?
      @booking_number = params['booking_number']
      @ticket_number = params['ticket_number']
      @name = params['name']
      @age = params['age'].to_i
      @document_number = params['document_number']
      @document_type = params['document_type']
    end
  end

  def call
    booking_response = get_response_booking
    if !booking_response
      return {error: "This booking is not found", status: 406}
    else
      ticket_number = booking_response['ticket_number']
      ticket_price = booking_response['price']
    end
    if get_response_find
      return {error: "This user already has a ticket", status: 406}
    end
    if !normal_age?
      return {error: "Only for persons over 13 years old", status: 406}
    end
    sidekiq_response = delete_response_sidekiq
    if sidekiq_response != 200
      return {error: "Problems with sidekiq", status: sidekiq_response}
    end
    put_tickets_response = put_tickets_status
    if put_tickets_response != 200
      return {error: "Problems with tickets service", status: put_tickets_response}
    end
    post_user_response = post_user
    if post_user_response != 204
      return {error: "Problems with User service", status: post_user_response}
    end
    {result: true, ticket_number: ticket_number, ticket_price: ticket_price, status: 200}
  end

  private

  def get_response_booking
    end_point = "booking_number=#{@booking_number}"
    base_url = ENV['BOOKING_SERVICE_LINK'] + end_point
    begin
      # uri = URI.parse(base_url)
      response = HTTParty.get(base_url)
      if response.code == 200
        @ticket_number = JSON.parse(response.body)['ticket_number']
        JSON.parse(response.body)
      else
        nil
      end
    rescue
      nil
    end
  end

  def get_response_find
    end_point = "document_number=#{@document_number}"
    base_url = ENV['USER_FIND_SERVICE_LINK'] + end_point
    begin
      # uri = URI.parse(base_url)
      response = HTTParty.get(base_url)
      p response.body
      if response.body
        JSON.parse(response.body)
      else
        nil
      end
    rescue
      {error: "Server unavailable", status: 503}
    end
  end

  def normal_age?
    @age>13
  end

  def delete_response_sidekiq
    end_point = "booking_number=#{@booking_number}"
    base_url = ENV['SIDEKIQ_SERVICE_LINK'] + end_point
    begin
      #uri = URI.parse(base_url)
      response = HTTParty.delete(base_url)
      response.code
    rescue
      {error: "Server unavailable", status: 503}
    end
  end

  def put_tickets_status
    end_point = "ticket_number=#{@ticket_number}&status=purchased"
    base_url = ENV['TICKET_STATUS_SERVICE_LINK'] + end_point
    begin
      # uri = URI.parse(base_url)
      response = HTTParty.put(base_url)
      response.code
    rescue
      {error: "Server unavailable", status: 503}
    end
  end

  def post_user
    end_point = "ticket_number=#{@ticket_number}&name=#{@name}&age=#{@age}&document_number=#{@document_number}&document_type=#{@document_type}"
    base_url = ENV['USER_SERVICE_LINK'] + end_point
    begin
      # uri = URI.parse(base_url)
      response = HTTParty.post(base_url)
      response.code
    rescue
      {error: "Server unavailable", status: 503}
    end
  end

end