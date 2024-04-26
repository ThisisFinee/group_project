class UsersController < ApplicationController
  before_action :set_user, only: %i[ find find_block find_log ]

  # GET /users or /users.json
  # def index
    # @users = User.all
  # end

  # GET /users/new
  def new
    @user = User.new
  end

  def find
    render json: @user
  end

  def find_block
    render json: {'document_number'=>@user.document_number}
  end

  def find_log
    render json: {'user_name'=>@user.name}
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
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
