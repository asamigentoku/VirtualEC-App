require "test_helper"

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
  test "index returns users" do
    get api_users_path

    assert_response :success
    ids = JSON.parse(response.body).map { |u| u["id"] }
    assert_includes ids, users(:one).id
  end

  test "show returns the user" do
    get api_user_path(users(:one))

    assert_response :success
    assert_equal users(:one).email, JSON.parse(response.body)["email"]
  end

  test "show returns 404 for an unknown user" do
    get api_user_path(id: 0)

    assert_response :not_found
  end
end
