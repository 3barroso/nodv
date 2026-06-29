class Admin::UsersController < Admin::BaseController
  before_action :require_admin, only: [:create, :destroy, :index, :new]
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  before_action :authorize_profile_access, only: [:edit, :update, :show]

  def create
  end

  def destroy
  end

  def edit
  end

  def index
  end

  def show
    @authors = @user.authors.includes(:resources)
    @author_count = @authors.count
    @resource_count = @authors.sum { |author| author.resources.count }
  end

  def new
    @user = User.new
  end
  
  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def set_user
      if current_user.admin?
        @user = User.find(params[:id])
      else
        @user = current_user
      end
    end

    def authorize_profile_access
      return if current_user.admin? || @user == current_user

      redirect_to root_path, alert: "Access Denied."
    end

    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation)
    end
end
