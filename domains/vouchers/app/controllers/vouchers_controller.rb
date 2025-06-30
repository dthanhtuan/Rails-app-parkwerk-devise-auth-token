class VouchersController < ApplicationController
  before_action :authenticate_users_user!

  def index
    render json: { message: "Voucher INDEX API endpoint" }
  end

  def show
    render json: { message: "Voucher SHOW API endpoint", email: params[:email] }
  end
end

