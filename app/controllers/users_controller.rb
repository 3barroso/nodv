class UsersController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user_request = UserRequest.new
  end

  def create
    @user_request = UserRequest.new(user_request_params)

    if @user_request.save
      redirect_to new_user_path, notice: "Your request has been submitted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_request_params
      params.require(:user_request).permit(:email, :first_name, :last_name, :purpose, :reason, :document)
    end
end
