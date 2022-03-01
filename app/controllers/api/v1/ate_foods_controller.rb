class Api::V1::AteFoodsController < ApplicationController
  before_action(:logged_in_user)
  before_action(:set_day, only: [:index, :create])
  before_action(:set_ate_food, only: [:update, :destroy])
  before_action(:current_user_is_ate_food_owner, only: [:update, :destroy])
  before_action(:current_user_is_food_owner, only: [:create, :update])

  # GET /api/v1/days/:day_date/ate_foods
  def index
    render(json: @day.ate_foods, each_serializer: AteFoodSerializer)
  end

  # POST /api/v1/days/:day_date/ate_foods
  def create
    ate_food = @day.ate_foods.new(ate_food_params)
    if ate_food.save
      render(json: ate_food, serializer: AteFoodSerializer)
    else
      render(status: 400, json: ate_food.errors.full_messages)
    end
  end

  # PUT /api/v1/ate_foods/:id
  def update
    if @ate_food.update(ate_food_params)
      render(json: @ate_food, serializer: AteFoodSerializer)
    else
      render(status: 400, json: @ate_food.errors.full_messages)
    end
  end

  # DELETE /api/v1/ate_foods/:id
  def destroy
    @ate_food.destroy
    head(200)
  end

  private

  def ate_food_params
    params[:ate_food].permit(:amount, :food_id)
  end

  def set_day
    @day = current_user.days.find_by(date: params[:day_date])
    head(404) unless @day
  end

  def current_user_is_food_owner
    head(401) unless current_user.foods.ids.include?(ate_food_params[:food_id].to_i)
  end

  def set_ate_food
    @ate_food = AteFood.find_by(id: params[:id])
    head(404) unless @ate_food
  end

  def current_user_is_ate_food_owner
    head(401) unless current_user.ate_foods.include?(@ate_food)
  end
end
