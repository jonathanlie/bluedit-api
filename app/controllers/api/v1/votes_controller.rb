module Api
  module V1
    class VotesController < ApplicationController
      def create
        # Determine the votable type and find the record
        votable_type = determine_votable_type
        votable = votable_type.constantize.find(params["#{votable_type.downcase}_id"])

        # Find existing vote or build new one
        vote = votable.votes.find_or_initialize_by(user: current_user)
        vote.value = vote_params[:value]

        if vote.save
          render json: vote, status: :created
        else
          render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def vote_params
        params.require(:vote).permit(:value)
      end

      def determine_votable_type
        if params[:post_id]
          "Post"
        elsif params[:comment_id]
          "Comment"
        else
          raise ActionController::ParameterMissing, "Missing post_id or comment_id"
        end
      end
    end
  end
end
