class Product < ApplicationRecord
  # 商品が削除されても購入履歴（purchases）は残したいので、
  # 購入済みの商品を誤って削除できないよう restrict_with_error にしている
  # （購入履歴が1件でもあると destroy がエラーになり、削除がブロックされる）
  has_many :purchases, dependent: :restrict_with_error

  validates :title, presence: true, uniqueness: true
  # point_price: 0円（0ポイント）商品や負の値を防ぐため、正の整数のみ許可
  validates :point_price, presence: true,
                           numericality: { only_integer: true, greater_than: 0 }

  # 一覧表示などで「公開中の商品だけ」を簡単に取得できるようにするスコープ
  scope :active, -> { where(is_active: true) }

  # 作成・更新後にOpenSearchの検索インデックスへ反映する。
  # after_commit にしているのは、バリデーション失敗などでロールバックされた
  # 中途半端なデータをインデックスに載せてしまわないようにするため。
  after_commit :index_to_opensearch, on: %i[create update]
  after_commit :remove_from_opensearch, on: :destroy

  private

  def index_to_opensearch
    OpensearchClient.index_product(self)
  end

  def remove_from_opensearch
    OpensearchClient.delete_product(id)
  end
end
