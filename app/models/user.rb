class User < ApplicationRecord
  has_many(:categories, dependent: :destroy)
  has_many(:days, dependent: :destroy)

  has_secure_password

  validates(:email, email: true)
  validates(:password, password: true)

  class << self
    # JWT::DecodeErrorとActiveRecord::RecordNotFoundエラーが発生する可能性があるため使う際はrescueする
    def find_from_token(token)
      id = AuthToken.decode(token: token)[:sub]
      find(id)
    end
  end

  def create_token(lifetime: AuthToken.default_lifetime)
    AuthToken.create_token(sub: id, lifetime: lifetime)
  end

  # 自分以外の同じメアドで有効化されているユーザーが存在するか？
  def other_activated_user?
    other_user.where(activated: true, email: email).present?
  end

  # 自分以外の同じメアドで有効化されていないユーザーを返す
  def other_not_activated_user
    other_user.where(activated: false, email: email)
  end

  # カテゴリーテーブルとjoinした状態で、ユーザーのフードを取ってくる
  def foods
    Food.where(category_id: category_ids).eager_load(:category)
  end

  def bodies
    Body.where(day_id: day_ids).eager_load(:day)
  end

  def ate_foods
    AteFood.where(day_id: day_ids)
  end

  def dishes
    Dish.where(day_id: day_ids)
  end

  def weight_on(date)
    body_and_calory_pfc_on(date, :weight)
  end

  def percentage_on(date)
    body_and_calory_pfc_on(date, :percentage)
  end

  def calory_on(date)
    body_and_calory_pfc_on(date, :calory)
  end

  def protein_on(date)
    body_and_calory_pfc_on(date, :protein)
  end

  def fat_on(date)
    body_and_calory_pfc_on(date, :fat)
  end

  def carbonhydrate_on(date)
    body_and_calory_pfc_on(date, :carbonhydrate)
  end

  def average_month_weight(year, month)
    average_month_body(year, month, 'bodies.weight')
  end

  def average_month_percentage(year, month)
    average_month_body(year, month, 'bodies.percentage')
  end

  def average_month_calory(year, month)
    average_month_calory_and_pfc(year, month, :calory)
  end

  def average_month_protein(year, month)
    average_month_calory_and_pfc(year, month, :protein)
  end

  def average_month_fat(year, month)
    average_month_calory_and_pfc(year, month, :fat)
  end

  def average_month_carbonhydrate(year, month)
    average_month_calory_and_pfc(year, month, :carbonhydrate)
  end

  private

  def other_user
    User.where.not(id: id)
  end

  def body_and_calory_pfc_on(date, attr_name)
    days.find_by(date: date)&.send(attr_name) || 0
  end

  def month_days(year, month)
    days.where('YEAR(date) = ?', year).where('MONTH(date) = ?', month)
  end

  def average_month_body(year, month, attr_name)
    month_days(year, month).eager_load(:body).average(attr_name) || 0
  end

  def average_month_calory_and_pfc(year, month, attr_name)
    # dayはcaloryカラムを持っていないが、averageメソッドをCalculationsWrapperでハックしたため使える
    month_days(year, month).average(attr_name) || 0
  end
end
