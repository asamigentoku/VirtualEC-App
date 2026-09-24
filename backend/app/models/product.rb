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
end
