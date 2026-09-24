# OpenSearchクライアントのシングルトンラッパー。
# 商品の全文検索インデックス（products）への読み書きをここに集約する。
class OpensearchClient
  INDEX_NAME = "products"

  class << self
    def client
      @client ||= OpenSearch::Client.new(
        url: ENV.fetch("OPENSEARCH_URL", "http://localhost:9200"),
        # OpenSearchが落ちていてもRailsプロセス全体が固まらないよう、短めのタイムアウトにしている
        transport_options: { request: { timeout: 3 } }
      )
    end

    # インデックスが存在しない場合のみ作成する（初回セットアップ用。何度実行しても安全）
    def ensure_index!
      return if client.indices.exists(index: INDEX_NAME)

      client.indices.create(
        index: INDEX_NAME,
        body: {
          mappings: {
            properties: {
              title: { type: "text" },
              description: { type: "text" },
              point_price: { type: "integer" },
              is_active: { type: "boolean" }
            }
          }
        }
      )
    end

    def index_product(product)
      client.index(
        index: INDEX_NAME,
        id: product.id,
        body: {
          title: product.title,
          description: product.description,
          point_price: product.point_price,
          is_active: product.is_active
        }
      )
    rescue StandardError => e
      # 検索インデックスの更新に失敗しても、商品自体の保存（本業）は失敗させたくないのでログのみ
      Rails.logger.warn("[OpenSearch] index failed (product_id=#{product.id}): #{e.class}: #{e.message}")
    end

    def delete_product(product_id)
      client.delete(index: INDEX_NAME, id: product_id)
    rescue StandardError => e
      # 存在しないドキュメントの削除失敗なども含め、検索インデックス側のエラーで
      # 商品削除自体を失敗させたくないのでログのみに留める
      Rails.logger.warn("[OpenSearch] delete failed (product_id=#{product_id}): #{e.class}: #{e.message}")
    end

    def search(query)
      response = client.search(
        index: INDEX_NAME,
        body: {
          query: {
            multi_match: {
              query: query,
              fields: %w[title description]
            }
          }
        }
      )
      response["hits"]["hits"].map { |hit| hit["_id"].to_i }
    rescue StandardError => e
      # OpenSearchが落ちている場合は「検索結果0件」として振る舞い、APIの500エラーを避ける
      Rails.logger.warn("[OpenSearch] search failed (query=#{query}): #{e.class}: #{e.message}")
      []
    end
  end
end
