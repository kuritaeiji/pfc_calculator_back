module Chart::Month
  # front側から受け取ったparams[:month]を元に過去10カ月間の月の初日のdateオブジェクトを返す。
  # また、過去10カ月間の要素に対してブロックで評価した結果を返す
  def last_10_months(&block)
    (0..9).map do |n|
      month_date = end_month_date.ago(n.month)
      block.call(month_date)
    end.reverse
  end

  private

  def end_month_date
    @end_month_date ||= "#{params[:month]}-01".to_date
  end
end
