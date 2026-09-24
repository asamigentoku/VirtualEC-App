class Api::ProductsController < ApplicationController
  def index
    # デフォルトでは公開中(is_active: true)の商品のみ返す。
    # ?include_inactive=true が付いた場合のみ非公開商品も含めて全件返す（管理用途を想定）。
    products = params[:include_inactive] == "true" ? Product.all : Product.active
    render json: products
  end

  def show
    # 存在しないIDの場合は Product.find が例外を投げ、
    # ApplicationController の rescue_from で404に変換される
    render json: Product.find(params[:id])
  end
end
