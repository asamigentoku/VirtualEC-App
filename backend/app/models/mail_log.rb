class MailLog < ApplicationRecord
  # 現状は「商品お届けメール」のみ想定。将来メール種別が増えたらここに追加する
  MAIL_TYPES = %w[product_delivery].freeze
  # pending: 送信待ち（Resend未連携のため現状はここで止まる） / sent: 送信済み / failed: 送信失敗
  STATUSES = %w[pending sent failed].freeze

  belongs_to :purchase

  validates :mail_type, presence: true, inclusion: { in: MAIL_TYPES }
  # recipient_email: 誤ったアドレスへの送信ログを防ぐため形式チェック
  validates :recipient_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  # status: nil（未設定）は許容しつつ、値が入る場合は想定外の文字列を防ぐ
  validates :status, inclusion: { in: STATUSES }, allow_nil: true
end
