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

  # 自分以外の同じメアドで有効化されているユーザーを返す
  def other_activated_user?
    other_user.where(activated: true, email: email).present?
  end

  # カテゴリーテーブルとjoinした状態で、ユーザーのフードを取ってくる
  def foods
    Food.where(category_id: category_ids).eager_load(:category)
  end

  def bodies
    Body.where(day_id: day_ids).eager_load(:day)
  end

  private

  def other_user
    User.where.not(id: id)
  end
end
