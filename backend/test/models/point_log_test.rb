require "test_helper"

class PointLogTest < ActiveSupport::TestCase
  test "valid with known log_type and non-zero point" do
    log = PointLog.new(user: users(:one), log_type: "login_bonus", point: 10, description: "test")
    assert log.valid?
  end

  test "invalid with unknown log_type" do
    log = PointLog.new(user: users(:one), log_type: "unknown", point: 10, description: "test")
    assert_not log.valid?
  end

  test "invalid with zero point" do
    log = PointLog.new(user: users(:one), log_type: "login_bonus", point: 0, description: "test")
    assert_not log.valid?
  end

  test "invalid without description" do
    log = PointLog.new(user: users(:one), log_type: "login_bonus", point: 10)
    assert_not log.valid?
  end
end
