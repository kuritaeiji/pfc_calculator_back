class Api::V1::BodiesController < ApplicationController
  before_action(:logged_in_user)
  before_action(:set_day, only: [:create])
  before_action(:already_created_body, only: [:create])
  before_action(:set_body, only: [:weight, :percentage])

  # POST /api/v1/days/:day_date/bodies
  def create
    @day.body = Body.new(weight: 0, percentage: 0)
    render(json: @day.body, serializer: BodySerializer)
  end

  # PUT /api/v1/bodies/:id/weight
  def weight
    update(weight_params)
  end

  # PUT /api/v1/bodies/:id/percentage
  def percentage
    update(percentage_params)
  end

  private

  def update(params)
    if @body.update(params)
      render(json: @body, serializer: BodySerializer)
    else
      render(status: 400, json: @body.errors.full_messages)
    end
  end

  def weight_params
    params[:body].permit(:weight)
  end

  def percentage_params
    params[:body].permit(:percentage)
  end

  def set_day
    @day = current_user.days.find_by(date: params[:day_date])
    head(404) unless @day
  end

  def already_created_body
    body = @day.body
    render(json: body, serializer: BodySerializer) if body
  end

  def set_body
    @body = current_user.bodies.find_by(id: params[:id])
    head(404) unless @body
  end
end
