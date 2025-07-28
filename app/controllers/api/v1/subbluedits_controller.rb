module Api
  module V1
    class SubblueditsController < ApplicationController
      skip_before_action :authenticate_request, only: [ :show ]

      def show
        subbluedit = Subbluedit.find(params[:id])
        render json: subbluedit, include: :posts
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
