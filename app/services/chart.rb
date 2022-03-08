module Chart
  def line_date_weight_data
    create_line_date_body_data(:weight)
  end

  def line_date_percentage_data
    create_line_date_body_data(:percentage)
  end

  def line_month_weight_data
    (0..9).map do |n|
      date = end_month_date.ago(n.month)
      current_user.average_month_weight(date.year, date.month)
    end.reverse
  end

  def line_month_percentage_data
    (0..9).map do |n|
      date = end_month_date.ago(n.month)
      current_user.average_month_percentage(date.year, date.month)
    end.reverse
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

  def end_date
    @end_date ||= params[:date].to_date
  end

  def end_month_date
    @end_month_date ||= "#{params[:month]}-01".to_date
  end

  def create_line_date_body_data(body_attr_name)
    (0..9).map do |n|
      date = end_date.ago(n.day)
      current_user.days.find_by(date: date)&.body&.send(body_attr_name) || 0
    end.reverse
  end
end
