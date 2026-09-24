class User < ApplicationRecord
  has_many :purchases, dependent: :destroy
  has_many :point_logs, dependent: :destroy

  # clerk_user_id: Clerk（認証サービス）側のユーザーIDを想定。重複登録を防ぐため一意制約をつけている
  validates :clerk_user_id, presence: true, uniqueness: true
  # email: 形式チェックと重複チェックを行い、不正な値や二重登録を防ぐ
  validates :email, presence: true, uniqueness: true,
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  # point_balance: マイナス残高になることを防ぐため 0以上の整数のみ許可
  validates :point_balance, presence: true,
                             numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
