require "test_helper"

class Api::V1::VotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @post = posts(:two)  # Use post two which doesn't have votes from user one
    @comment = comments(:three)  # Use comment three which doesn't have votes from user one
  end

  test "should not create vote without auth" do
    post api_v1_subbluedit_post_vote_url(@post.subbluedit, @post),
      params: { vote: { value: 1 } }
    assert_response :unauthorized
  end

  test "should create vote on post with auth" do
    assert_difference("Vote.count") do
      post api_v1_subbluedit_post_vote_url(@post.subbluedit, @post),
        params: { vote: { value: 1 } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
  end

  test "should create vote on comment with auth" do
    assert_difference("Vote.count") do
      post api_v1_comment_vote_url(@comment),
        params: { vote: { value: -1 } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
  end

  test "should update existing vote on post" do
    # Create initial vote
    post api_v1_subbluedit_post_vote_url(@post.subbluedit, @post),
      params: { vote: { value: 1 } },
      headers: { "Authorization" => "Bearer #{@token}" }

    # Update vote (should not create new record)
    assert_no_difference("Vote.count") do
      post api_v1_subbluedit_post_vote_url(@post.subbluedit, @post),
        params: { vote: { value: -1 } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
  end

  test "should not create vote with invalid value" do
    post api_v1_subbluedit_post_vote_url(@post.subbluedit, @post),
      params: { vote: { value: 2 } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :unprocessable_entity
  end
end
