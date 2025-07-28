require "test_helper"

class ApiV1SubblueditsFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
  end

  test "can create and fetch subbluedit with auth" do
    post api_v1_subbluedits_url,
      params: { subbluedit: { name: "FlowSub", description: "Flow desc" } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :created
    sub_id = JSON.parse(@response.body)["id"]

    get api_v1_subbluedit_url(sub_id)
    assert_response :success
    assert_match "FlowSub", @response.body
  end

  test "cannot create subbluedit without auth" do
    post api_v1_subbluedits_url, params: { subbluedit: { name: "NoAuth", description: "desc" } }
    assert_response :unauthorized
  end
end
