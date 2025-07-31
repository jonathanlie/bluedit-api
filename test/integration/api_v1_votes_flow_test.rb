require "test_helper"

class ApiV1VotesFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
    @subbluedit = subbluedits(:one)
  end

  test "can create post and vote with auth" do
    # Create a post in an existing subbluedit
    post api_v1_subbluedit_posts_url(@subbluedit.name),
      params: { post: { title: "Vote Post", body: "Vote body" } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :created
    post_id = JSON.parse(@response.body)["id"]

    # Vote on the post
    assert_difference("Vote.count") do
      post api_v1_subbluedit_post_vote_url(@subbluedit.name, post_id),
        params: { vote: { value: 1 } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
  end

  test "can create comment and vote with auth" do
    post = posts(:one)

    # Create a comment
    post api_v1_subbluedit_post_comments_url(post.subbluedit.name, post.id),
      params: { comment: { body: "Vote comment" } },
      headers: { "Authorization" => "Bearer #{@token}" }
    assert_response :created
    comment_id = JSON.parse(@response.body)["id"]

    # Vote on the comment
    assert_difference("Vote.count") do
      post api_v1_comment_vote_url(comment_id),
        params: { vote: { value: -1 } },
        headers: { "Authorization" => "Bearer #{@token}" }
    end
    assert_response :created
  end

  test "cannot vote without auth" do
    post = posts(:one)
    post api_v1_subbluedit_post_vote_url(post.subbluedit.name, post.id),
      params: { vote: { value: 1 } }
    assert_response :unauthorized
  end
end
