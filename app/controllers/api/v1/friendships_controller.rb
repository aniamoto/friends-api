module Api::V1
  class FriendshipsController < ApplicationController
    before_action :validate_emails, only: [:create, :mutual_friends]
    before_action :set_user, only: [:create, :user_friends, :mutual_friends]

    # POST /api/v1/friends
    def create
      @user.friends << User.find_by!(email: @email2)
      render_success
    end

    # GET /api/v1/friends
    def user_friends
      friends = @user.friend_list
      render_list_with_count('friends', friends)
    end

    # GET /api/v1/mutual_friends
    def mutual_friends
      user2 = User.find_by!(email: @email2)
      friends = @user.mutual_friends(user2)

      render_list_with_count('friends', friends)
    end

    private

      def set_user
        email = params[:email] || params[:friends]&.first
        @user = User.find_by!(email: email)
      end

      def validate_emails
        @email1, @email2 = params[:friends]
        # I18n, hardcoded text is bad
        if @email1.nil? || @email2.nil? || @email1.casecmp(@email2).zero?
          json_response({ message: 'Two unique emails are required' }, :unprocessable_entity)
        end
      end
  end
end
