module Vouchers
  class ApiController < ApplicationController

    def index
      render json: { message: "Voucher API endpoint" }
    end
  end
end
