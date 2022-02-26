class Api::V1::BodiesController < ApplicationController
  before_action(:logged_in_user)
  before_action(:set_day, only: [:create])
  before_action(:already_created_body, only: [:create])
  before_action(:set_body, only: [:update])
  before_action(:current_user_is_body_owner, only: [:update])

  # POST /api/v1/days/:day_date/bodies
  def create
    @day.body = Body.new(weight: 0, percentage: 0)
    render(json: @day.body, serializer: BodySerializer)
  end

  # PUT /api/v1/bodies/:id
  def update
    if @body.update(body_params)
      render(json: @body, serializer: BodySerializer)
    else
      render(status: 400, json: @body.errors.full_messages)
    end
  end

  private

  def body_params
    params[:body].permit(:weight, :percentage)
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
    @body = Body.find_by(id: params[:id])
    head(404) unless @body
  end

  def current_user_is_body_owner
    head(401) unless current_user.bodies.include?(@body)
  end
end
