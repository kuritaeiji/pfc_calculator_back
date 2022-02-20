class Api::V1::UserTokenController < ApplicationController
  # POST /api/v1/login
  def create
    login
  end

  private

  def auth_params
    params[:auth].permit(:email, :password)
  end
end
