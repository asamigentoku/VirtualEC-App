class Api::ProductsController < ApplicationController
  def index
    # 商品一覧は読み取りが多く更新が少ないため、Redis(Rails.cache)でキャッシュする。
    # キャッシュキーに「最終更新日時」を含めることで、商品が作成・更新・削除されたら
    # 自動的に別のキーになり、古いキャッシュを参照し続けることがないようにしている
    # （明示的なキャッシュ削除処理を書かずに済む＝キャッシュ無効化漏れによるバグを防げる）。
    cache_key = [ "api/products/index", params[:include_inactive] == "true", Product.maximum(:updated_at)&.to_i ]

    products = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      scope = params[:include_inactive] == "true" ? Product.all : Product.active
      scope.to_a.as_json
    end

    render json: products
  end

  def show
    # 存在しないIDの場合は Product.find が例外を投げ、
    # ApplicationController の rescue_from で404に変換される
    render json: Product.find(params[:id])
  end

  # OpenSearchを使ったキーワード全文検索。
  # DBの LIKE 検索と違い、日本語の形態素解析・関連度順のソートなどが利用できる。
  def search
    ids = OpensearchClient.search(params[:q].to_s)

    # OpenSearchが返した「関連度順」を保つため、取得後にRuby側で順序を並べ直す
    # （Product.where(id: ids) だけだとDBの主キー順になってしまう）
    products_by_id = Product.where(id: ids).index_by(&:id)
    ordered_products = ids.filter_map { |id| products_by_id[id] }

    render json: ordered_products
  end
end
