class Api::V1::UsersController < ApplicationController
  before_action(:logged_in_user, only: [:destroy])

  # POST /api/v1/signup
  def create
    user = User.new(user_params)
    if user.save
      UserMailer.with(user: user).activate_user_email.deliver_later
      render(status: 200)
    else
      render(status: 400, json: user.errors.full_messages)
    end
  end

  # PUT /api/v1/activate
  def update
    activate_user
  end

  # DELETE /api/v1/withdraw
  def destroy
    current_user.destroy
    head(:ok)
  end

  private

  def user_params
    params[:user].permit(:email, :password)
  end

  def activate_params
    params.permit(:token)
  end
end
