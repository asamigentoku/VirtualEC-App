class Api::PurchasesController < ApplicationController
  # Purchase.purchase! が投げるエラーを、それぞれ適切なHTTPステータスに変換する。
  # ここで拾わないと、業務エラー（残高不足など）がそのまま例外として
  # 500エラーになってしまい、フロント側でエラー内容を判別できなくなる。
  rescue_from Purchase::InsufficientPointsError, with: :render_insufficient_points
  rescue_from Purchase::AlreadyPurchasedError, with: :render_already_purchased
  rescue_from Purchase::ProductNotAvailableError, with: :render_product_not_available

  def index
    purchases = Purchase.all
    # user_id が指定された場合のみ絞り込む（未指定なら全件返す）
    purchases = purchases.where(user_id: params[:user_id]) if params[:user_id].present?
    render json: purchases
  end

  def show
    render json: Purchase.find(params[:id])
  end

  def create
    # Clerk認証が未実装のため、現状は user_id をパラメータで直接受け取る暫定仕様。
    # 存在しないIDが渡された場合は User.find / Product.find が
    # ActiveRecord::RecordNotFound を投げ、ApplicationController 側で404に変換される。
    user = User.find(params[:user_id])
    product = Product.find(params[:product_id])

    # 実際の購入処理（残高チェック・排他ロック等）は Purchase.purchase! に集約している
    purchase = Purchase.purchase!(user: user, product: product)

    render json: purchase, status: :created
  end

  private

  # 422: リクエスト自体は正しいが、ビジネスルール上処理できない（残高不足）
  def render_insufficient_points(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  # 409: 既に存在する状態と競合している（二重購入）
  def render_already_purchased(exception)
    render json: { error: exception.message }, status: :conflict
  end

  # 422: 商品が非公開などの理由で処理できない
  def render_product_not_available(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
