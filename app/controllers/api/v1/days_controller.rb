class Api::V1::DaysController < ApplicationController
  before_action(:logged_in_user)
  before_action(:already_created_day, only: [:create])
  before_action(:set_day, only: [:show])

  # GET /api/v1/days/:date
  def show
    render(json: @day, serializer: DaySerializer)
  end

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

  def set_day
    @day = current_user.days.find_by(date: params[:date])
    head(404) unless @day 
  end
end
