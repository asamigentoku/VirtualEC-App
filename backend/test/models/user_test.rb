require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with clerk_user_id and email" do
    user = User.new(clerk_user_id: "user_new", email: "new@example.com", point_balance: 0)
    assert user.valid?
  end

  test "invalid without clerk_user_id" do
    user = User.new(email: "new@example.com")
    assert_not user.valid?
    assert_includes user.errors[:clerk_user_id], "can't be blank"
  end

  test "invalid with duplicate clerk_user_id" do
    user = User.new(clerk_user_id: users(:one).clerk_user_id, email: "another@example.com")
    assert_not user.valid?
  end

  test "invalid with duplicate email" do
    user = User.new(clerk_user_id: "user_unique", email: users(:one).email)
    assert_not user.valid?
  end

  test "invalid with malformed email" do
    user = User.new(clerk_user_id: "user_unique", email: "not-an-email")
    assert_not user.valid?
  end

  test "invalid with negative point_balance" do
    user = User.new(clerk_user_id: "user_unique", email: "unique@example.com", point_balance: -1)
    assert_not user.valid?
  end
end
