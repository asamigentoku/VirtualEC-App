class PointLog < ApplicationRecord
  # 想定しているポイント獲得・消費の種類を列挙しておき、
  # log_type に想定外の文字列（typoなど）が入らないようにしている
  LOG_TYPES = %w[
    github_commit
    qiita_post
    login_bonus
    referral
    google_form_review
    admin_grant
    purchase
  ].freeze

  belongs_to :user

  validates :log_type, presence: true, inclusion: { in: LOG_TYPES }
  # point: 0だと「何も起きていないログ」になってしまうため、
  # DB側の check_constraint（point <> 0）と合わせてアプリ側でも 0 を禁止している
  validates :point, presence: true, numericality: { only_integer: true, other_than: 0 }
  # description: どんな理由でポイントが増減したか必ず記録させる（履歴の可読性のため）
  validates :description, presence: true
end
