module Chart::Date
  # frontから受け取ったparams[:date]を元に過去10日間のDateオブジェクトを返す。
  # また、過去10日間の要素に対してブロックで評価した結果を返す
  def last_10_days(&block)
    (0..9).map do |n|
      date = end_date.ago(n.day)
      block.call(date)
    end.reverse
  end

  private

  def end_date
    @end_date ||= params[:date].to_date
  end
end
