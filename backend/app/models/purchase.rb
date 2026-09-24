class Purchase < ApplicationRecord
  # 「残高不足」「二重購入」「非公開商品の購入」を、それぞれ別のエラークラスとして定義。
  # こうしておくことで、コントローラ側で rescue_from を使い、
  # エラーの種類ごとに異なるHTTPステータス（422 / 409 など）を返せるようにしている。
  class InsufficientPointsError < StandardError; end
  class AlreadyPurchasedError < StandardError; end
  class ProductNotAvailableError < StandardError; end

  belongs_to :user
  belongs_to :product
  has_one :mail_log, dependent: :destroy

  # after_commit を使う理由：
  # after_create だと「トランザクションの途中」でコールバックが走ってしまい、
  # 万が一この後の処理（例外）でロールバックされた場合にも
  # 「購入完了」イベントを配信してしまう恐れがある。
  # after_commit ならトランザクションが確定した後にだけ発火するため、
  # 実際にDBへ確定した購入だけがKafkaへ流れることを保証できる。
  after_commit :publish_purchase_completed_event, on: :create

  validates :point_used, presence: true,
                          numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  # DB側にも (user_id, product_id) のユニークインデックスがあるが、
  # モデル側でもバリデーションしておくことで、保存前にエラーメッセージ付きで弾けるようにしている。
  validates :user_id, uniqueness: { scope: :product_id }

  # 購入処理の本体。
  # 「残高チェック」と「ポイント減算」の間に他のリクエストが割り込むと、
  # 残高がマイナスになったり同じ商品が二重に購入されたりする可能性がある（競合状態）。
  # それを防ぐため、
  #   1. transaction で全体を1つの取引としてまとめ、途中で失敗したら全部ロールバックする
  #   2. lock!（SELECT ... FOR UPDATE 相当）で対象の user / product 行をロックし、
  #      同時に別リクエストが同じユーザー・商品を処理できないようにする
  # という2段構えでエラーを回避している。
  def self.purchase!(user:, product:)
    transaction do
      user.lock!
      product.lock!

      # 商品が非公開（is_active: false）の場合は購入不可
      raise ProductNotAvailableError, "この商品は現在購入できません" unless product.is_active

      # 同じユーザー・商品の組み合わせで既に購入済みなら、二重購入としてエラーにする
      if exists?(user_id: user.id, product_id: product.id)
        raise AlreadyPurchasedError, "この商品はすでに購入済みです"
      end

      # ポイント残高が商品価格に満たない場合はエラーにする
      if user.point_balance < product.point_price
        raise InsufficientPointsError, "ポイントが不足しています"
      end

      # ここまでのチェックを通過したら、購入レコードを作成
      purchase = create!(user: user, product: product, point_used: product.point_price)

      # ユーザーの残高からポイントを減算
      user.update!(point_balance: user.point_balance - product.point_price)

      # ポイントの増減履歴として point_log にも記録（監査・履歴表示用）
      user.point_logs.create!(
        log_type: "purchase",
        point: -product.point_price,
        description: "「#{product.title}」を購入"
      )

      # 商品お届けメールの送信ログを作成。
      # Resend連携は未実装のため、実際の送信は行わず status: "pending"（送信待ち）としている。
      MailLog.create!(
        purchase: purchase,
        mail_type: "product_delivery",
        recipient_email: user.email,
        subject: "「#{product.title}」をお届けします",
        status: "pending"
      )

      purchase
    end
  end

  private

  # 購入完了イベントをKafkaへpublishする。
  # このイベントは bin/rails kafka:consume（Consumer側）が購読し、
  # 「メールお届けログをsent状態に更新する」という非同期処理を後から行う。
  def publish_purchase_completed_event
    EventPublisher.publish(
      "purchase.completed",
      key: id,
      purchase_id: id,
      user_id: user_id,
      product_id: product_id,
      point_used: point_used,
      occurred_at: created_at
    )
  end
end
