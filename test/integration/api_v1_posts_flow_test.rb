require "test_helper"

class ApiV1PostsFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @subbluedit = subbluedits(:one)
  end

  test "can create post with auth" do
    post api_v1_subbluedit_posts_url(@subbluedit.name),
      params: { post: { title: "Flow Post", body: "Body text" } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :created
    assert_match "Flow Post", @response.body
  end

  test "cannot create post without auth" do
    post api_v1_subbluedit_posts_url(@subbluedit.name), params: { post: { title: "NoAuth", body: "desc" } }
    assert_response :unauthorized
  end
end
