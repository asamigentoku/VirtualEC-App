require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid with title and positive point_price" do
    product = Product.new(title: "New product", point_price: 100)
    assert product.valid?
  end

  test "invalid without title" do
    product = Product.new(point_price: 100)
    assert_not product.valid?
  end

  test "invalid with duplicate title" do
    product = Product.new(title: products(:one).title, point_price: 100)
    assert_not product.valid?
  end

  test "invalid with zero point_price" do
    product = Product.new(title: "Zero price", point_price: 0)
    assert_not product.valid?
  end

  test "active scope returns only active products" do
    products(:one).update!(is_active: true)
    products(:two).update!(is_active: false)

    assert_includes Product.active, products(:one)
    assert_not_includes Product.active, products(:two)
  end

  test "after_commit indexes the product into OpenSearch on create" do
    indexed = nil
    stub_singleton_method(OpensearchClient, :index_product, ->(product) { indexed = product }) do
      Product.create!(title: "OpenSearch Indexing Test", point_price: 100)
    end

    assert_equal "OpenSearch Indexing Test", indexed&.title
  end

  test "after_commit removes the product from OpenSearch on destroy" do
    product = Product.create!(title: "To be removed from OpenSearch", point_price: 100)

    deleted_id = nil
    stub_singleton_method(OpensearchClient, :delete_product, ->(id) { deleted_id = id }) do
      product.destroy!
    end

    assert_equal product.id, deleted_id
  end
end
