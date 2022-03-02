module Chart
  def line_date_weight_data
    create_line_date_body_data(:weight)
  end

  def line_date_percentage_data
    create_line_date_body_data(:percentage)
  end

  def line_month_weight_data
  end

  def line_percentage_month_data
  end

  def line_calory_day_data
  end

  def line_calory_month_data
  end

  def line_pfc_day_data
  end

  def line_pfc_month_chart
  end

  private

  def start_date
    @start_date ||= end_date - 10
  end

  def end_date
    @end_date ||= params[:date].to_date + 1
  end

  def create_line_date_body_data(body_attr_name)
    days = current_user.days.where(date: start_date...end_date).eager_load(:body)

    (start_date...end_date).to_a.reduce([]) do |data, date|
      day = days.find_by(date: date)
      data << (day&.body&.send(body_attr_name) || 0)
    end
  end
end
