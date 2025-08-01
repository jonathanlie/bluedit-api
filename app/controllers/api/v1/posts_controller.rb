module Api
  module V1
    class PostsController < ApplicationController
      skip_before_action :authenticate_request, only: [ :show ]

      def show
        post = Post.find(params[:id])
        render json: post, include: [
          :user,
          :subbluedit,
          :votes,
          comments: {
            include: [ :user, :votes, :replies ]
          }
        ]
      end

      def create
        subbluedit = Subbluedit.find_by(name: params[:subbluedit_name])
        if subbluedit
          post = subbluedit.posts.build(post_params.merge(user: current_user))
          if post.save
            render json: post, status: :created
          else
            render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Subbluedit not found" }, status: :not_found
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
