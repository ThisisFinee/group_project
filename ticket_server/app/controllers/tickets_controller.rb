class TicketsController < ApplicationController
  STATUS = %w[ free purchased booking block ]
  CATEGORY = %w[ vip fan ]

  skip_before_action :verify_authenticity_token
  
  before_action :validate_ticket_number, only: %i[ show block update ]
  before_action :validate_status, only: :update
  before_action :validate_category, only: :free
  before_action :set_ticket, only: %i[ show update block ]

 # GET /tickets/ticket_number=1
  def show
    response = {
      category: @ticket.category, 
      event_date: @ticket.event_date,
      ticket_status: @ticket.status 
    }
    render json: response, status: :ok
end

 # PUT /tickets/block?ticket_number=1&document_number=123456
  def block
    #get user and check document and status sold
    block, message = TicketsService.check_block_conditions(@ticket.ticket_number, @ticket.status, params[:document_number])
    unless block
      render json: message, status: :not_acceptable
      return
    end
    
    #update ticket with status = block
    if @ticket.update(status: 'block')
      render json: 'Status updated', status: :ok
    else
      render json: @ticket.errors, status: :not_acceptable 
    end
  end


  # GET /tickets/free?category=vip&event_date=2024-10-10
  def free
    event_date = params[:event_date].to_date
    free_tickets_count = Ticket.all.where("category = ? and event_date = ? and status = ?", params[:category], event_date, 'free').count

    if free_tickets_count.zero?
      render json: 'No available tickets', status: :not_found
    else
      ticket_number = Ticket.all.where("category = ? and event_date = ? and status = ?", params[:category], event_date, 'free').first.ticket_number
      price = TicketsService.calculate_ticket_cost(free_tickets_count, params[:category])
      @ticket = {ticket_number: ticket_number, price: price}
      render json: @ticket, status: :ok
    end
  end

  # PUT /tickets/status?ticket_number=1&status=free
  def update
      if @ticket.update(status: params[:status])
        render json: 'Status updated', status: :ok
      else
        render json: @ticket.errors, status: :not_acceptable 
      end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find_by(ticket_number: params[:ticket_number].to_i)
      unless @ticket.present?
        render json: 'Ticket with such number does not exist', status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def ticket_params
      params.require(:ticket).permit(:ticket_number, :category, :status, :event_date)
    end

    def validate_ticket_number
      number = Integer(params[:ticket_number])
      number.positive?
    rescue ArgumentError, TypeError
      render json: 'Invalid ticket number', status: :not_acceptable
    end

    def validate_status
      unless STATUS.include?(params[:status])
        render json: 'Invalid ticket status', status: :not_acceptable
      end
    end

    def validate_category
      unless CATEGORY.include?(params[:category])
        render json: 'Invalid ticket category', status: :not_acceptable
      end
    end
end
