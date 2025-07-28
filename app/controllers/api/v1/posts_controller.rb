module Api
  module V1
    class PostsController < ApplicationController
      def create
        subbluedit = Subbluedit.find(params[:subbluedit_id])
        post = subbluedit.posts.build(post_params.merge(user: current_user))
        if post.save
          render json: post, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
