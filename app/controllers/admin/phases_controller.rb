class Admin::PhasesController < Admin::BaseController
  before_action :require_admin

  def index
    @phases = Phase.main_phases.includes(:sub_phases).order(:position)
  end

  def new
  end

  def edit
  end

  def create
  end

  def destroy
  end

  def move_up
    @phase = Phase.find(params[:id])
    if @phase.parent.present?
      @phase.move_higher
    else
      # moving a main phase (parent) will move the whole section
      @phase.move_higher
    end

    respond_to do |format|
      format.html { redirect_to admin_phases_path }
      format.json { render json: { success: true } }
      format.turbo_stream do
        @phases = Phase.main_phases.includes(:sub_phases).order(:position)
        render turbo_stream: turbo_stream.replace('admin_phases_list', partial: 'admin/phases/list', locals: { phases: @phases })
      end
    end
  end

  def move_down
    @phase = Phase.find(params[:id])
    if @phase.parent.present?
      @phase.move_lower
    else
      @phase.move_lower
    end

    respond_to do |format|
      format.html { redirect_to admin_phases_path }
      format.json { render json: { success: true } }
      format.turbo_stream do
        @phases = Phase.main_phases.includes(:sub_phases).order(:position)
        render turbo_stream: turbo_stream.replace('admin_phases_list', partial: 'admin/phases/list', locals: { phases: @phases })
      end
    end
  end
end
