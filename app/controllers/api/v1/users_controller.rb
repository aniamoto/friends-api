module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /api/v1/users
    def index
      @users = User.all
       json_response(@users)
    end

    # GET /api/v1/users/1
    def show
       json_response(@user)
    end

    # POST /api/v1/users
    def create
      @user = User.create!(user_params)
      json_response(@user, :created)
    end

    # PATCH/PUT /api/v1/users/1
    def update
      @user.update(user_params)
      head :no_content
    end

    # DELETE /api/v1/users/1
    def destroy
      @user.destroy
      head :no_content
    end

    private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.permit(:email)
      end
  end
end
