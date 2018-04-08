module Api::V1
  class FriendshipsController < ApplicationController
    include EmailValidationHelper
    before_action :set_emails, only: [:create, :mutual_friends]
    before_action :set_user, only: [:user_friends]
    before_action :set_users, only: [:create, :mutual_friends]

    # POST /api/v1/friends
    def create
      if @user1.friendship_possible?(@user2)
        @user1.friends << @user2
        render_success
      else
        # I18n, hardcoded text is bad
        json_response({ message: 'Cannot create friendship with blocked user' }, :error)
      end
    end

    # GET /api/v1/friends
    def user_friends
      friends = @user.friend_list
      render_list_with_count('friends', friends)
    end

    # GET /api/v1/mutual_friends
    def mutual_friends
      friends = @user1.mutual_friends(@user2)
      render_list_with_count('friends', friends)
    end

    private

      def set_user
        @user = User.find_by!(email: params[:email])
      end

      def set_users
        @user1 = User.find_by!(email: @email1)
        @user2 = User.find_by!(email: @email2)
      end

      def set_emails
        params[:friends] ||= []
        @email1, @email2 = validate_emails(params[:friends])
      end
  end
end
