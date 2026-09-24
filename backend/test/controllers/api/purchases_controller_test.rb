require "test_helper"

class Api::PurchasesControllerTest < ActionDispatch::IntegrationTest
  test "create purchases a product and deducts points" do
    user = users(:two)
    product = products(:two)
    starting_balance = user.point_balance

    post api_purchases_path, params: { user_id: user.id, product_id: product.id }

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal product.point_price, body["point_used"]
    assert_equal starting_balance - product.point_price, user.reload.point_balance
  end

  test "create returns 422 when points are insufficient" do
    user = users(:two)
    product = products(:two)
    product.update!(point_price: 999_999)

    post api_purchases_path, params: { user_id: user.id, product_id: product.id }

    assert_response :unprocessable_entity
  end

  test "create returns 409 when already purchased" do
    post api_purchases_path, params: { user_id: users(:one).id, product_id: products(:one).id }

    assert_response :conflict
  end

  test "create returns 404 for an unknown user" do
    post api_purchases_path, params: { user_id: 0, product_id: products(:one).id }

    assert_response :not_found
  end

  test "index filters by user_id" do
    get api_purchases_path(user_id: users(:one).id)

    assert_response :success
    body = JSON.parse(response.body)
    assert body.all? { |purchase| purchase["user_id"] == users(:one).id }
  end
end
