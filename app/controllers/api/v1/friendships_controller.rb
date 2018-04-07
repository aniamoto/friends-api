module Api::V1
  class FriendshipsController < ApplicationController
    before_action :validate_friendship, only: :create

    # POST /api/v1/friends
    def create
      User.find_by!(email: @email1).friends << User.find_by!(email: @email2)
      render_success
    end

    private

      def validate_friendship
        # I18n, hardcoded text is bad
        if friend_params[:friends].size < 2
          return json_response({ message: 'Friendship creation requires two emails' }, :unprocessable_entity)
        end

        @email1, @email2 = friend_params[:friends]
        if @email1.casecmp(@email2).zero?
          json_response({ message: 'User cannot friend themselves!' }, :unprocessable_entity)
        end
      end

      def friend_params
        params.permit(friends: [])
      end
  end
end
