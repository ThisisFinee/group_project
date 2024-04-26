class UsersController < ApplicationController
  before_action :set_user, only: %i[ find_block find_log ]
  skip_before_action :verify_authenticity_token

  # GET /users or /users.json
  # def index
    # @users = User.all
  # end

  # GET /users/new
  def new
    @user = User.new
  end

  def find
    @user = User.find_by(document_number: params['document_number'])
    render json: @user, status: 200
  end

  def find_block
    render json: {'document_number'=>@user.document_number}, status: 200
  end

  def find_log
    render json: {'user_name'=>@user.name}, status: 200
  end

  # POST /users or /users.json
  def create
    par = {ticket_number: params['ticket_number'], name: params['name'], age: params['age'], document_number: params['document_number'], document_type: params['document_type']}
    @user = User.new(par)
    @user.save!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(ticket_number: params['ticket_number'].to_i)
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:ticket_number, :name, :age, :document_number, :document_type)
    end
end
