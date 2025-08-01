require "test_helper"

class Api::V1::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @post = posts(:one)
  end

  test "should not create comment without auth" do
    post api_v1_subbluedit_post_comments_url(@post.subbluedit, @post),
      params: { comment: { body: "Test comment" } }
    assert_response :unauthorized
  end

  test "should create comment with auth" do
    assert_difference("Comment.count") do
      post api_v1_subbluedit_post_comments_url(@post.subbluedit, @post),
        params: { comment: { body: "Test comment" } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
    assert_match "Test comment", @response.body
  end

  test "should create nested comment with auth" do
    parent_comment = comments(:one)
    assert_difference("Comment.count") do
      post api_v1_subbluedit_post_comments_url(@post.subbluedit, @post),
        params: { comment: { body: "Reply to comment", parent_comment_id: parent_comment.id } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
    assert_match "Reply to comment", @response.body
  end

  test "should not create comment with invalid params" do
    post api_v1_subbluedit_post_comments_url(@post.subbluedit, @post),
      params: { comment: { body: "" } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :unprocessable_entity
  end
end
