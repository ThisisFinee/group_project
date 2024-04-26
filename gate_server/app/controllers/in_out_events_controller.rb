class InOutEventsController < ApplicationController
  before_action :set_in_out_event, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  # GET /in_out_events or /in_out_events.json
  def index
    @in_out_events = InOutEvent.all

    params.keys.each do |key|
      case key
      when 'ticket_number'
        @in_out_events = @in_out_events.where(ticket_number: params[:ticket_number])
      when 'status'
        @in_out_events = @in_out_events.where(status: params[:status])
      when 'date_time'
        @in_out_events = @in_out_events.where(date_time: params[:date_time])
      when 'user_name'
        @in_out_events = @in_out_events.where(user_name: params[:user_name])
      when 'user_action'
        @in_out_events = @in_out_events.where(user_action: params[:user_action])
      end
    end
    render json: @in_out_events
  end

  # GET /in_out_events/1 or /in_out_events/1.json
  def show
  end

  # GET /in_out_events/new
  def new
    @in_out_event = InOutEvent.new
  end

  # GET /in_out_events/1/edit
  def edit
  end

  # POST /in_out_events or /in_out_events.json
  def create
    @in_out_event = InOutEvent.new(in_out_event_params)

    respond_to do |format|
      if @in_out_event.save
        format.html { redirect_to in_out_event_url(@in_out_event), notice: "In out event was successfully created." }
        format.json { render :show, status: :created, location: @in_out_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @in_out_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /in_out_events/1 or /in_out_events/1.json
  def update
    respond_to do |format|
      if @in_out_event.update(in_out_event_params)
        format.html { redirect_to in_out_event_url(@in_out_event), notice: "In out event was successfully updated." }
        format.json { render :show, status: :ok, location: @in_out_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @in_out_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /in_out_events/1 or /in_out_events/1.json
  def destroy
    @in_out_event.destroy

    respond_to do |format|
      format.html { redirect_to in_out_events_url, notice: "In out event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_in_out_event
      @in_out_event = InOutEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def in_out_event_params
      params.require(:in_out_event).permit(:ticket_number, :user_name, :date_time, :user_action, :status)
    end
end
