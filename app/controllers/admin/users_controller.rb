class Admin::UsersController < ApplicationController
  before_action :require_admin, only: [:create, :destroy, :index, :new]
  before_action :set_user, only: [:edit, :update, :show, :destroy]

  def create
  end

  def destroy
  end

  def edit
  end

  def index
  end

  def show
  end

  def new
    @user = User.new
  end
  
  def update
  end

  private

    def set_user
      if current_user.admin?
        @user = User.find(params[:id])
      else
        redirect_to root_path, alert: "Access Denied." if current_user.id != params[:id]
        @user = current_user
      end
    end
end
