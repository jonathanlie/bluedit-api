require "test_helper"

class ApiV1CommentsFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @subbluedit = subbluedits(:one)
  end

  test "can create post and comment with auth" do
    # Create a post in an existing subbluedit
    post api_v1_subbluedit_posts_url(@subbluedit.name),
      params: { post: { title: "Test Post", body: "Test body" } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :created
    post_id = JSON.parse(@response.body)["id"]

    # Create a comment on the post
    assert_difference("Comment.count") do
      post api_v1_subbluedit_post_comments_url(@subbluedit.name, post_id),
        params: { comment: { body: "Great post!" } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
    assert_match "Great post!", @response.body
  end

  test "cannot create comment without auth" do
    post = posts(:one)
    post api_v1_subbluedit_post_comments_url(post.subbluedit.name, post.id),
      params: { comment: { body: "Test comment" } }
    assert_response :unauthorized
  end
end
