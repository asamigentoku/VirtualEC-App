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
end
