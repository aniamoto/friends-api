module Api::V1
  class SubscriptionsController < ApplicationController
    include EmailValidationHelper
    before_action :set_emails, only: :create
    before_action :set_user, only: :recipients
    before_action :set_users, only: :create

    # POST /api/v1/subscriptions
    def create
      @requestor.subscriptions << @target
      render_success
    end

    # GET /api/v1/recipients
    def recipients
      mentions = params[:text].scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i)
      recipients = @user.recipients | mentions

      render_list('recipients', recipients)
    end

    private

      def set_user
        @user = User.find_by!(email: params[:sender])
      end

      def set_users
        @requestor = User.find_by!(email: @email1)
        @target = User.find_by!(email: @email2)
      end

      def set_emails
        emails = [params[:requestor], params[:target]]
        @email1, @email2 = validate_emails(emails)
      end
  end
end
