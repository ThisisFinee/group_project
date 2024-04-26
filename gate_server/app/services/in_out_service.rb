class InOutService
  def self.pass_allowed?(ticket_number, category, user_action, current_date)
    @ticket = TicketService.find_ticket_by_number(ticket_number)
    @user = TicketService.find_user_by_ticket_number(ticket_number)
    @user_action = user_action
    @current_date = current_date.to_time

    last_user_event = self.last_successful_event_by_user_name(@user[:user_name])
    last_user_event = {user_action: 'out'} if last_user_event.nil?

    return false unless @ticket[:status] == 'active' and
                        @ticket[:event_date].to_time.year == @current_date.year and
                        @ticket[:event_date].to_time.yday == @current_date.yday and
                        @ticket[:category] == category and
                        @user_action != last_user_event[:user_action]
    return true
  end

  def self.last_successful_event_by_user_name(user_name)
    InOutEvent.where(user_name: user_name, status: true).last
  end

  def self.event_log(status)
    InOutEvent.create(date_time: @current_date,
                      user_name: @user[:user_name],
                      user_action: @user_action,
                      status: status)
  end
end