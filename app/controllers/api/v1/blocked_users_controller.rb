module Api::V1
  class BlockedUsersController < ApplicationController
    include EmailValidationHelper
    before_action :set_emails, only: :create
    before_action :set_users, only: :create

    # POST /api/v1/block_user
    def create
      @requestor.blocks_users << @target
      render_success
    end

    private

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
