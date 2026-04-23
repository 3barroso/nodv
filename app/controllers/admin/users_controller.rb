class Admin::UsersController < ApplicationController
  before_action :require_admin, only: [:create, :destroy, :index, :new]
  # show/edit can only edit themselves

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
  end
end
