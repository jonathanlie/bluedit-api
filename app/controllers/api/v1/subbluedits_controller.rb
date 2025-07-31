module Api
  module V1
    class SubblueditsController < ApplicationController
      skip_before_action :authenticate_request, only: [ :show ]

      def show
        subbluedit = Subbluedit.find_by(name: params[:name])
        if subbluedit
          render json: subbluedit, include: [
            :user,
            posts: {
              include: [:user, :votes, :comments]
            }
          ]
        else
          render json: { error: "Subbluedit not found" }, status: :not_found
        end
      end

      def create
        subbluedit = current_user.subbluedits.build(subbluedit_params)
        if subbluedit.save
          render json: subbluedit, status: :created
        else
          render json: { errors: subbluedit.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def subbluedit_params
        params.require(:subbluedit).permit(:name, :description)
      end
    end
  end
end
