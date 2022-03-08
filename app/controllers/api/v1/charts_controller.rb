class Api::V1::ChartsController < ApplicationController
  include(Chart)
  before_action(:logged_in_user)

  # GET /api/v1/charts/date_weight?date=2020-02-02
  def date_weight
    render(json: { chart: date_weight_data })
  end

  # GET /api/v1/charts/date_percentage?date=2020-01-01
  def date_percentage
    render(json: { chart: date_percentage_data })
  end

  # GET /api/v1/charts/month_weight?month=2020-10
  def month_weight
    render(json: { chart: month_weight_data })
  end

  # GET /api/v1/charts/month_percentage?month=2020-10
  def month_percentage
    render(json: { chart: month_percentage_data })
  end

  # GET /api/v1/charts/date_calory?=date=2020-01-01
  def date_calory
    render(json: { chart: date_calory_data })
  end

  # GET /api/v1/charts/date_protein?=date=2020-01-01
  def date_protein
    render(json: { chart: date_protein_data })
  end

  # GET /api/v1/charts/date_fat?=date=2020-01-01
  def date_fat
    render(json: { chart: date_fat_data })
  end

  # GET /api/v1/charts/date_carbonhydrate?=date=2020-01-01
  def date_carbonhydrate
    render(json: { chart: date_carbonhydrate_data })
  end

  # GET /api/v1/charts/month_calory?=month=2020-01
  def month_calory
    render(json: { chart: month_calory_data })
  end

  # GET /api/v1/charts/month_protein?=month=2020-01
  def month_protein
    render(json: { chart: month_protein_data })
  end

  # GET /api/v1/charts/month_fat?=month=2020-01
  def month_fat
    render(json: { chart: month_fat_data })
  end

  # GET /api/v1/charts/month_carbonhydrate?=month=2020-01
  def month_carbonhydrate
    render(json: { chart: month_carbonhydrate_data })
  end
end
