require "test_helper"

class ApiV1PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @subbluedit = subbluedits(:one)
  end

  test "should not create post without auth" do
    post api_v1_subbluedit_posts_url(@subbluedit), params: { post: { title: "T", body: "B" } }
    assert_response :unauthorized
  end

  test "should create post with auth" do
    assert_difference("Post.count") do
      post api_v1_subbluedit_posts_url(@subbluedit),
        params: { post: { title: "New Post", body: "Body text" } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
    assert_match "New Post", @response.body
  end

  test "should not create post with invalid params" do
    post api_v1_subbluedit_posts_url(@subbluedit),
      params: { post: { title: "", body: "" } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :unprocessable_entity
  end
end
