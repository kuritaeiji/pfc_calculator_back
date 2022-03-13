module Chart
  include(Date)
  include(Body)
  include(Month)
  include(CaloryPfc)

  def date_weight_data
    last_10_days do |date|
      body_on_date(:weight, date)
    end
  end

  def date_percentage_data
    last_10_days do |date|
      body_on_date(:percentage, date)
    end
  end

  def month_weight_data
    last_10_months do |month_date|
      body_on_month(:weight, month_date)
    end
  end

  def month_percentage_data
    last_10_months do |month_date|
      body_on_month(:percentage, month_date)
    end
  end

  def date_calory_data
    last_10_days do |date|
      calory_pfc_on_date(:calory, date)
    end
  end

  def date_protein_data
    last_10_days do |date|
      calory_pfc_on_date(:protein, date)
    end
  end

  def date_fat_data
    last_10_days do |date|
      calory_pfc_on_date(:fat, date)
    end
  end

  def date_carbonhydrate_data
    last_10_days do |date|
      calory_pfc_on_date(:carbonhydrate, date)
    end
  end

  def month_calory_data
    last_10_months do |month_date|
      calory_pfc_on_month(:calory, month_date)
    end
  end

  def month_protein_data
    last_10_months do |month_date|
      calory_pfc_on_month(:protein, month_date)
    end
  end

  def month_fat_data
    last_10_months do |month_date|
      calory_pfc_on_month(:fat, month_date)
    end
  end

  def month_carbonhydrate_data
    last_10_months do |month_date|
      calory_pfc_on_month(:carbonhydrate, month_date)
    end
  end
end
