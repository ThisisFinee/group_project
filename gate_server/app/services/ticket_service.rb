require 'typhoeus'
class TicketService
  TICKETS_SERVICE_URL = "http://ticket_server:3000/tickets?"
  USERS_SERVICE_URL = "http://user_server:3000/users/log?"

  def self.find_ticket_by_number(ticket_number)
    base_url = TICKETS_SERVICE_URL+"ticket_number=#{ticket_number}"
    result = Typhoeus.get(base_url)
    p result
    raise 'NotFound' unless result.code == 200
    JSON.parse(result.body)
    # @ticket = {
    #   ticket_number: number,
    #   category: 'vip',
    #   event_date: Time.now,
    #   status: 'purchased'
    # }
  end

  def self.find_user_by_ticket_number(ticket_number)
    base_url = USERS_SERVICE_URL + "ticket_number=#{ticket_number}"
    result = Typhoeus.get(base_url)
    
    raise 'NotFound' unless result.code == 200
    JSON.parse(result.body)
    # @user = {
    #   user_name: 'Ivan Egorov'
    # }
  end
end