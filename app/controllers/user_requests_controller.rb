class UserRequestsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user_request = UserRequest.new
  end

  def create
    @user_request = UserRequest.new(user_request_params)

    # make user creation logic in helper so it can be called anywhere
    @user = User.new(user_params)

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

    def user_params
      params.require(:user_request).permit(:email)
      # add in @user_request.id ? (or tie with user request object through email after creation?)
      # include password creation on user_request ? (yes)
    end
end
