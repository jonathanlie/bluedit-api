require "test_helper"

class ApiV1SubblueditsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @subbluedit = subbluedits(:one)
  end

  test "should show subbluedit" do
    get api_v1_subbluedit_url(@subbluedit.name)
    assert_response :success
    assert_match @subbluedit.name, @response.body
  end

  test "should not create subbluedit without auth" do
    post api_v1_subbluedits_url, params: { subbluedit: { name: "Test", description: "Desc" } }
    assert_response :unauthorized
  end

  test "should create subbluedit with auth" do
    assert_difference("Subbluedit.count") do
      post api_v1_subbluedits_url,
        params: { subbluedit: { name: "TestSub", description: "A desc" } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
    assert_match "TestSub", @response.body
  end

  test "should not create subbluedit with invalid params" do
    post api_v1_subbluedits_url,
      params: { subbluedit: { name: "", description: "" } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :unprocessable_entity
  end
end
