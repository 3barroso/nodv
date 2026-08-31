class UserRequestsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user_request = UserRequest.new
  end

  def create
    if UserRequest.exists?(email: user_request_params[:email]) && (!current_user || current_user.email != user_request_params[:email])
      redirect_to new_user_request_path, alert: "Account already exists for this email, please sign in to create new request" and return
    end

    @user_request = UserRequest.new(user_request_params)

    # before save insure email is unique or that the user creating a new request is signed in as that user's email
    if @user_request.save
      if @user_request.created_user.present?
        start_new_session_for(@user_request.created_user)
        redirect_to root_path, notice: "Your request has been submitted. You are now signed in."
      else
        redirect_to new_user_request_path, alert: "Your request was saved, but we could not create your account."
      end
    else
      render :new, status: :unprocessable_entity
      # check that error message comes through here (model -> previous request has not yet been reviewed)
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to create user for request: #{e.message}")
    @user_request.errors.add(:base, "We could not create your account. Please review the details and try again.")
    render :new, status: :unprocessable_entity
  end

  private
    def user_request_params
      params.require(:user_request).permit(:email, :first_name, :last_name, :purpose, :reason, :document, :password, :password_confirmation)
    end
end
