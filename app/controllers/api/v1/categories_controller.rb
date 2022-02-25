class Api::V1::CategoriesController < ApplicationController
  before_action(:logged_in_user)
  before_action(:set_category, only: [:update, :destroy])

  # GET /api/v1/categories
  def index
    render(json: current_user.categories, each_serializer: CategorySerializer, root: 'categories', adapter: :json)
  end

  # POST /api/v1/categories
  def create
    category = current_user.categories.new(category_params)
    if category.save
      render(json: category, serializer: CategorySerializer, root: 'category', adapter: :json)
    else
      render(status: 400, json: category.errors.full_messages)
    end
  end

  # PUT /api/v1/category/:id
  def update
    if @category.update(category_params)
      render(json: @category, serializer: CategorySerializer, root: 'category', adapter: :json)
    else
      render(status: 400, json: @category.errors.full_messages)
    end
  end

  # DELETE /api/v1/category/:id
  def destroy
    @category.destroy
    head(200)
  end

  private

  def category_params
    params[:category].permit(:title)
  end

  def set_category
    @category = Category.find_by(id: params[:id])
    head(404) unless @category
  end
end
