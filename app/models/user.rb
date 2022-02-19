class User < ApplicationRecord
  has_secure_password

  validates(:email, email: true)
  validates(:password, password: true)

  # 自分以外の同じメアドで有効化されているユーザーを返す
  def other_activated_user?
    other_user.where(activated: true, email: email).present?
  end

  private

  def other_user
    User.where.not(id: id)
  end
end
