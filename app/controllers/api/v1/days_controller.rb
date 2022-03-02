class Api::V1::DaysController < ApplicationController
  before_action(:logged_in_user)
  before_action(:already_created_day)

  # POST /api/v1/days
  def create
    day = current_user.days.create(day_params)
    render(json: day, serializer: DaySerializer)
  end

  private

  def day_params
    params[:day].permit(:date)
  end

  def already_created_day
    day = current_user.days.find_by(day_params)
    render(json: day, serializer: DaySerializer) if day
  end
end
