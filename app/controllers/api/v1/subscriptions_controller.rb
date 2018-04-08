module Api::V1
  class SubscriptionsController < ApplicationController
    before_action :validate_emails, only: :create
    before_action :set_user, only: :recipients
    before_action :set_users, only: :create

    # POST /api/v1/subscriptions
    def create
      @requestor.subscriptions << @target
      render_success
    end

    # GET /api/v1/recipients
    def recipients
      mentions = params[:text].scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i).uniq
      recipients = @user.recipients | mentions

      render_list_with_count('recipients', recipients)
    end

    private

      def set_user
        @user = User.find_by!(email: params[:sender])
      end

      def set_users
        @requestor = User.find_by!(email: @email1)
        @target = User.find_by!(email: @email2)
      end

      def validate_emails
        @email1, @email2 = params[:requestor], params[:target]
        # I18n, hardcoded text is bad
        if @email1.nil? || @email2.nil? || @email1.casecmp(@email2).zero?
          json_response({ message: 'Two unique emails are required' }, :unprocessable_entity)
        end
      end
  end
end
