module Vouchers
  class StatusesController < ApplicationController
    before_action :authenticate_users_user!

    def show
      render json: { message: "Voucher Status Endpoint", code: params[:code] }
    end
  end
end
