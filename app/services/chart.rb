module Chart
  def date_weight_data
    create_date_body_data(:weight)
  end

  def date_percentage_data
    create_date_body_data(:percentage)
  end

  def month_weight_data
    create_month_body_data(:weight)
  end

  def month_percentage_data
    create_month_body_data(:percentage)
  end

  def date_calory_data
    create_date_calory_and_pfc_data(:calory)
  end

  def date_protein_data
    create_date_calory_and_pfc_data(:protein)
  end

  def date_fat_data
    create_date_calory_and_pfc_data(:fat)
  end

  def date_carbonhydrate_data
    create_date_calory_and_pfc_data(:carbonhydrate)
  end

  def month_calory_data
    create_month_calory_and_prc_data(:calory)
  end

  def month_protein_data
    create_month_calory_and_prc_data(:protein)
  end

  def month_fat_data
    create_month_calory_and_prc_data(:fat)
  end

  def month_carbonhydrate_data
    create_month_calory_and_prc_data(:carbonhydrate)
  end

  private

  def end_date
    @end_date ||= params[:date].to_date
  end

  def end_month_date
    @end_month_date ||= "#{params[:month]}-01".to_date
  end

  def create_date_body_data(attr_name)
    (0..9).map do |n|
      date = end_date.ago(n.day)
      current_user.days.find_by(date: date)&.body&.send(attr_name) || 0
    end.reverse
  end

  def create_month_body_data(attr_name)
    (0..9).map do |n|
      date = end_month_date.ago(n.month)
      current_user.send("average_month_#{attr_name}", date.year, date.month)
    end.reverse
  end

  def create_date_calory_and_pfc_data(attr_name)
    (0..9).map do |n|
      current_user.days.find_by(date: end_date.ago(n.day))&.send(attr_name) || 0
    end.reverse
  end

  def create_month_calory_and_prc_data(attr_name)
    (0..9).map do |n|
      date = end_month_date.ago(n.month)
      current_user.send("average_month_#{attr_name}", date.year, date.month)
    end.reverse
  end
end
