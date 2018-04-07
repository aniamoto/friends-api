module Api::V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /users
    def index
      @users = User.all
       json_response(@users)
    end

    # GET /users/1
    def show
       json_response(@user)
    end

    # POST /users
    def create
      @user = User.create!(user_params)
      json_response(@user, :created)
    end

    # PATCH/PUT /users/1
    def update
      @user.update(user_params)
      head :no_content
    end

    # DELETE /users/1
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
