class UserRequestsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user_request = UserRequest.new
  end

  def create
    @user_request = UserRequest.new(user_request_params)

    if @user_request.save
      user = create_user_from_request
      if user.persisted?
        start_new_session_for(user)
        redirect_to root_path, notice: "Your request has been submitted. You are now signed in."
      else
        redirect_to new_session_path, alert: "Your request was saved, but we could not create your account."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_request_params
      params.require(:user_request).permit(:email, :first_name, :last_name, :purpose, :reason, :document)
    end

    def user_params
      params.require(:user_request).permit(:password, :password_confirmation)
    end

    def create_user_from_request
      user = User.new(email: @user_request.email, password: user_params[:password], password_confirmation: user_params[:password_confirmation])
      user.save!
      @user_request.update!(created_user: user)
      user
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to create user for request #{@user_request.id}: #{e.message}")
      user
    end
end
