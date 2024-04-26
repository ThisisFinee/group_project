class TicketService
  TICKETS_SERVICE_URL = "http://ticket_service:3000/"
  USERS_SERVICE_URL = "http://user_service:3000/users/log"

  def self.find_ticket_by_number(number)
    clnt = HTTPClient.new
    result = clnt.get(USERS_SERVICE_URL, {number: number})

    raise 'NotFound' unless result[:status] == 200
    @ticket = result
    # @ticket = {
    #   ticket_number: number,
    #   category: 'vip',
    #   event_date: Time.now,
    #   status: 'active'
    # }
  end

  def self.find_user_by_ticket_number(ticket_number)
    clnt = HTTPClient.new
    result = clnt.get(USERS_SERVICE_URL, {ticket_number: ticket_number})
    
    raise 'NotFound' unless result[:status] == 200
    @user = result
    # @user = {
    #   ticket_number: ticket_number,
    #   user_name: 'Ivan Egorov',
    #   age: 21,
    #   document_number: '1234 567890',
    #   document_type: 'passport'
    # }
  end
end