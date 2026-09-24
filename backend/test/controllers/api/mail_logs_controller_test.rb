require "test_helper"

class Api::MailLogsControllerTest < ActionDispatch::IntegrationTest
  test "index filters by purchase_id" do
    get api_mail_logs_path(purchase_id: purchases(:one).id)

    assert_response :success
    body = JSON.parse(response.body)
    assert body.present?
    assert body.all? { |log| log["purchase_id"] == purchases(:one).id }
  end

  test "show returns the mail log" do
    get api_mail_log_path(mail_logs(:one))

    assert_response :success
  end
end
