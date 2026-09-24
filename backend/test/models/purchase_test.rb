require "test_helper"

class PurchaseTest < ActiveSupport::TestCase
  test "purchase! deducts points and creates point_log and mail_log" do
    user = users(:one)
    product = products(:two)
    starting_balance = user.point_balance

    purchase = Purchase.purchase!(user: user, product: product)

    assert purchase.persisted?
    assert_equal product.point_price, purchase.point_used
    assert_equal starting_balance - product.point_price, user.reload.point_balance

    last_log = user.point_logs.order(:created_at).last
    assert_equal "purchase", last_log.log_type
    assert_equal(-product.point_price, last_log.point)

    assert_not_nil purchase.mail_log
    assert_equal "pending", purchase.mail_log.status
  end

  test "purchase! raises InsufficientPointsError when balance is too low" do
    user = users(:two)
    product = products(:two)
    product.update!(point_price: 999_999)

    assert_raises(Purchase::InsufficientPointsError) do
      Purchase.purchase!(user: user, product: product)
    end
  end

  test "purchase! raises AlreadyPurchasedError for a duplicate purchase" do
    user = users(:one)
    product = products(:one)

    assert_raises(Purchase::AlreadyPurchasedError) do
      Purchase.purchase!(user: user, product: product)
    end
  end

  test "purchase! raises ProductNotAvailableError for an inactive product" do
    user = users(:one)
    product = products(:two)
    product.update!(is_active: false)

    assert_raises(Purchase::ProductNotAvailableError) do
      Purchase.purchase!(user: user, product: product)
    end
  end
end
