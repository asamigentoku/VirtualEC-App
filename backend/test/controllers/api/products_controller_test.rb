require "test_helper"

class Api::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "index returns only active products by default" do
    products(:one).update!(is_active: true)
    products(:two).update!(is_active: false)

    get api_products_path

    assert_response :success
    ids = JSON.parse(response.body).map { |p| p["id"] }
    assert_includes ids, products(:one).id
    assert_not_includes ids, products(:two).id
  end

  test "show returns the product" do
    get api_product_path(products(:one))

    assert_response :success
    assert_equal products(:one).title, JSON.parse(response.body)["title"]
  end

  test "show returns 404 for an unknown product" do
    get api_product_path(id: 0)

    assert_response :not_found
  end

  test "search returns products in the order OpenSearch ranked them" do
    # OpenSearchの実サーバーが無くてもテストが決定的に通るよう、
    # クライアント部分（OpensearchClient.search）だけをスタブに差し替える
    expected_ids = [ products(:two).id, products(:one).id ]
    stub_singleton_method(OpensearchClient, :search, ->(_query) { expected_ids }) do
      get search_api_products_path(q: "test")
    end

    assert_response :success
    ids = JSON.parse(response.body).map { |p| p["id"] }
    assert_equal expected_ids, ids
  end

  test "search returns an empty array when there are no matches" do
    stub_singleton_method(OpensearchClient, :search, ->(_query) { [] }) do
      get search_api_products_path(q: "no-such-keyword")
    end

    assert_response :success
    assert_equal [], JSON.parse(response.body)
  end
end
