class Api::V1::FoodsController < ApplicationController
  before_action(:logged_in_user)
  before_action(:set_food, only: [:update, :destroy])
  before_action(:current_user_is_food_user, only: [:update, :destroy])

  # GET /api/v1/foods
  def index
    render(json: current_user.foods, each_serializer: FoodSerializer)
  end

  # POST /api/v1/foods
  def create
    food = Food.new(food_params)
    if food.save
      render(json: food, serializer: FoodSerializer)
    else
      render(status: 400, json: food.errors.full_messages)
    end
  end

  # PUT /api/v1/foods/:id
  def update
    if @food.update(food_params)
      render(json: @food, serializer: FoodSerializer)
    else
      render(status: 400, json: @food.errors.full_messages)
    end
  end

  # DELETE /api/v1/foods/:id
  def destroy
    @food.destroy
    head(200)
  end

  private

  def current_user_is_food_user
    head(401) unless current_user == @food.user
  end

  def set_food
    @food = Food.find_by(id: params[:id])
    head(404) unless @food
  end

  def food_params
    params[:food].permit(:title, :per, :unit, :calory, :protein, :fat, :carbonhydrate, :category_id)
  end
end
