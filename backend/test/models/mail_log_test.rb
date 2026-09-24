require "test_helper"

class MailLogTest < ActiveSupport::TestCase
  test "valid with known mail_type and recipient_email" do
    log = MailLog.new(purchase: purchases(:one), mail_type: "product_delivery",
                       recipient_email: "a@example.com", status: "pending")
    assert log.valid?
  end

  test "invalid with malformed recipient_email" do
    log = MailLog.new(purchase: purchases(:one), mail_type: "product_delivery",
                       recipient_email: "not-an-email")
    assert_not log.valid?
  end

  test "invalid with unknown status" do
    log = MailLog.new(purchase: purchases(:one), mail_type: "product_delivery",
                       recipient_email: "a@example.com", status: "unknown")
    assert_not log.valid?
  end
end
