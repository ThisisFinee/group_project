class GateController < ApplicationController
  skip_before_action :verify_authenticity_token

  # rescue_from Exception do |e|
    # render json: {status: 404, result: false}, status: :not_found
  # end

  def pass
    @ticket_number = params[:ticket_number]
    @category = params[:category]
    @user_action = params[:user_action]
    @current_date = params[:current_date]

    pass_allowed = InOutService.pass_allowed?(@ticket_number, @category, @user_action, @current_date)
    InOutService.event_log(pass_allowed)

    render json: {status: 200, result: pass_allowed}, status: :ok
  end
end
