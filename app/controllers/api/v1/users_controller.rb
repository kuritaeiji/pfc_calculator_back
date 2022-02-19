class Api::V1::UsersController < ApplicationController
  # POST /api/v1/signup
  def create
    user = User.new(user_params)
    if user.save
      UserMailer.with(user: user).activate_user_email.deliver_later
    else
      render(status: 400, json: user.errors.full_messages)
    end
  end

  # PUT /api/v1/activate
  def update
  end

  private

  def user_params
    params[:user].permit(:email, :password)
  end

  def activate_params
    params.permit(:token)
  end
end
