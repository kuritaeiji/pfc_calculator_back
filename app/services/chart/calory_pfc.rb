module Chart::CaloryPfc
  # とある日付のカロリーまたはPFCを返す
  def calory_pfc_on_date(attr_name, date)
    current_user.send("#{attr_name}_on", date)
  end

  # とある月の平均カロリーまたはPFCを返す
  def calory_pfc_on_month(attr_name, month_date)
    current_user.send("average_month_#{attr_name}", month_date.year, month_date.month)
  end
end
