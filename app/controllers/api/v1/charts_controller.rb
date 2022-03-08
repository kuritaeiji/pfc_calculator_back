class Api::V1::ChartsController < ApplicationController
  include(Chart)
  before_action(:logged_in_user)

  # GET /api/v1/charts/date_weight?date=2020-02-02
  def date_weight
    render(json: { chart: line_date_weight_data })
  end

  # GET /api/v1/charts/date_percentage?date=2020-01-01
  def date_percentage
    render(json: { chart: line_date_percentage_data })
  end

  # GET /api/v1/charts/month_weight?month=2020-10
  def month_weight
    render(json: { chart: line_month_weight_data })
  end

  # GET /api/v1/charts/month_percentage?month=2020-10
  def month_percentage
    render(json: { chart: line_month_percentage_data })
  end
end
