class UserRequestsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    if current_user
      latest_request = current_user.user_requests.order(created_at: :desc).first

      if latest_request.nil?
        @user_request = UserRequest.new
        return
      end

      if latest_request.draft?
        @user_request = latest_request
        return
      end

      # If latest was submitted and rejected, create a new draft copy
      if latest_request.submitted? && latest_request.rejected?
        @user_request = latest_request.remake_rejected_request
        return
      end

      # Otherwise show the existing request status to the user
      redirect_to admin_user_request_path(latest_request) and return
    else
      @user_request = UserRequest.new
    end
  end

  def create
    email = user_request_params[:email]

    # If an account already exists for this email and the requester is not
    # signed in as that user, redirect to the sign-in page with a neutral notice so we don't reveal account existence.
    if User.exists?(email: email) && (!current_user || current_user.email != email)
      redirect_to new_session_path, notice: "System is processing your request. Please sign in or reset your password." and return
    end

    # If there's already a pending submitted request for this email and the requester is not the signed-in owner, redirect to sign-in with a neutral notice.
    if UserRequest.pending.where(email: email, submitted: true).exists? && (!current_user || current_user.email != email)
      redirect_to new_session_path, notice: "System is processing your request. Please sign in to check status." and return
    end

    @user_request = UserRequest.new(user_request_params)

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
