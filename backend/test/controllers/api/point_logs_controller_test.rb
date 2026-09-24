require "test_helper"

class Api::PointLogsControllerTest < ActionDispatch::IntegrationTest
  test "index filters by user_id" do
    get api_point_logs_path(user_id: users(:one).id)

    assert_response :success
    body = JSON.parse(response.body)
    assert body.present?
    assert body.all? { |log| log["user_id"] == users(:one).id }
  end
end
