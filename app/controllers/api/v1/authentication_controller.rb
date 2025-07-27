module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request, only: [ :google_oauth2 ]

      def google_oauth2
        Rails.logger.info "Rails: Received Google OAuth request"
        google_token = params.require(:google_token)
        Rails.logger.info "Rails: Token length: #{google_token.length}"

        begin
          Rails.logger.info "Rails: Verifying Google token with client ID: #{ENV['GOOGLE_CLIENT_ID']}"
          payload = Google::Auth::IDTokens.verify_oidc(google_token, aud: ENV["GOOGLE_CLIENT_ID"])

          Rails.logger.info "Rails: Token verified, payload: #{payload['email']}"
          identity = Identity.find_by(provider: "google", provider_id: payload["sub"])

          if identity.nil?
            Rails.logger.info "Rails: Creating new user for email: #{payload['email']}"
            user = User.find_or_create_by(email: payload["email"]) do |u|
              u.name = payload["name"]
              u.avatar_url = payload["picture"]
            end
            identity = user.identities.create(provider: "google", provider_id: payload["sub"])
          else
            Rails.logger.info "Rails: Found existing user for email: #{payload['email']}"
          end

          user = identity.user
          internal_token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
          Rails.logger.info "Rails: Generated internal token for user: #{user.id}"
          render json: { token: internal_token, user: user }, status: :ok

        rescue Google::Auth::IDTokens::VerificationError => e
          render json: { error: "Invalid Google Token: #{e.message}" }, status: :unauthorized
        end
      end
    end
  end
end
