class Admin::UserRequestsController < Admin::BaseController
  before_action :require_admin, only: [ :destroy, :index ]
  before_action :set_user_request, except: [ :index ]
  before_action :authorize_user_request_access, only: [ :edit, :show, :update ]

  def edit
    if current_user&.admin?
      render :edit_reviewer
    elsif owner?
      render :edit_owner
    else
      redirect_to root_path, alert: "Access denied."
    end
  end

  def index
    @pending_user_requests = UserRequest.pending.order(created_at: :desc).limit(50)
    @total_user_requests_count = UserRequest.count
    @approved_requests_count = UserRequest.where(approved: true).count
    # should the .count be .size ? for performance ?(but then fails spec tests)
  end

  def destroy
  end

  def update
    if current_user&.admin?
      if @user_request.update(reviewer_update_params.merge(reviewed_by: current_user))
        redirect_to admin_user_request_path(@user_request), notice: "Request updated."
      else
        render :edit_reviewer, status: :unprocessable_entity
      end
    elsif owner?
      if @user_request.update(owner_update_params)
        redirect_to admin_user_request_path(@user_request), notice: "Your request has been updated."
      else
        render :edit_owner, status: :unprocessable_entity
      end
    else
      redirect_to root_path, alert: "Access denied."
    end
  end

  def show
  end

  private
    def set_user_request
      @user_request = UserRequest.find(params[:id])
    end

    def authorize_user_request_access
      return if current_user&.admin?
      return if owner?

      redirect_to root_path, alert: "Access denied."
    end

    def owner?
      return false unless session_user_email.present?

      @user_request.email == session_user_email
    end

    def session_user_email
      session_user = current_user || session[:user]

      if session_user.respond_to?(:email)
        session_user.email
      elsif session_user.is_a?(Hash)
        session_user["email"] || session_user[:email]
      end
    end

    def owner_update_params
      params.require(:user_request).permit(:first_name, :last_name, :purpose, :reason, :document)
    end

    def reviewer_update_params
      params.require(:user_request).permit(:approved, :rejection_reason, :reviewed)
    end
end