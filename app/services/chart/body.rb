module Chart::Body
  # とある日付の体重または体脂肪率を返す
  def body_on_date(attr_name, date)
    current_user.send("#{attr_name}_on", date)
  end

  # とある月の平均体重または平均体脂肪率を返す
  def body_on_month(attr_name, month_date)
    current_user.send("average_month_#{attr_name}", month_date.year, month_date.month)
  end
end
