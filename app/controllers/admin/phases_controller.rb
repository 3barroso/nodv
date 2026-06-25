class Admin::PhasesController < ApplicationController
  before_action :require_admin

  def new
  end

  def edit
  end

  def create
  end

  def index
    @phases = Phase.all.includes(:resources)
  end

  def destroy
  end
end
