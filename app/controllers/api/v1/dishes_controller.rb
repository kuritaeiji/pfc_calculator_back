class Api::V1::DishesController < ApplicationController
  before_action(:logged_in_user)
  before_action(:set_day, only: [:index, :create])
  before_action(:set_dish, only: [:update, :destroy])

  # GET /api/v1/days/:day_date/dishes
  def index
    render(json: @day.dishes, each_serializer: DishSerializer)
  end

  # POST /api/v1/days/:day_date/dishes
  def create
    dish = @day.dishes.new(dish_params)
    if dish.save
      render(json: dish, serializer: DishSerializer)
    else
      render(status: 400, json: dish.errors.full_messages)
    end
  end

  # PUT /api/v1/dishes/:id
  def update
    if @dish.update(dish_params)
      render(json: @dish, serializer: DishSerializer)
    else
      render(status: 400, json: @dish.errors.full_messages)
    end
  end

  # DELETE /api/v1/dishes/:id
  def destroy
    @dish.destroy
    head(200)
  end

  private

  def dish_params
    params[:dish].permit(:title, :calory, :protein, :fat, :carbonhydrate)
  end

  def set_day
    @day = current_user.days.find_by(date: params[:day_date])
    head(404) unless @day
  end

  def set_dish
    @dish = current_user.dishes.find_by(id: params[:id])
    head(404) unless @dish
  end
end
