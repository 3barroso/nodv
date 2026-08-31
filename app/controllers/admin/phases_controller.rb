class Admin::PhasesController < Admin::BaseController
  before_action :require_admin

  def index
    @phases = Phase.main_phases.includes(:sub_phases).order(:position)
  end

  def new
    @phase = Phase.new(parent_id: params[:parent_id])
    @parent = Phase.find_by(id: params[:parent_id]) if params[:parent_id].present?
  end

  def create
    # ensure only admins can create (extra safety)
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admins only." and return
    end

    @phase = Phase.new(phase_params)

    if @phase.save
      redirect_to edit_admin_phase_path(@phase), notice: "Phase created"
    else
      @parent = Phase.find_by(id: params.dig(:phase, :parent_id)) if params.dig(:phase, :parent_id).present?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Eager-load parent and sub-phases to avoid N+1 queries in the edit view
    @phase = Phase.includes(:parent, :sub_phases).find(params[:id])
    @sub_phases = @phase.sub_phases.order(:position)
  end

  def update
    @phase = Phase.find(params[:id])
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied. Admins only." and return
    end

    if @phase.update(phase_params)
      redirect_to edit_admin_phase_path(@phase), notice: "Phase updated"
    else
      @sub_phases = @phase.sub_phases.order(:position)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @phase = Phase.find(params[:id])
    @phase.destroy
    redirect_to admin_phases_path, notice: "Phase deleted"
  end

  def move_up
    @phase = Phase.find(params[:id])
    @phase.move_higher

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
    @phase.move_lower

    respond_to do |format|
      format.html { redirect_to admin_phases_path }
      format.json { render json: { success: true } }
      format.turbo_stream do
        @phases = Phase.main_phases.includes(:sub_phases).order(:position)
        render turbo_stream: turbo_stream.replace('admin_phases_list', partial: 'admin/phases/list', locals: { phases: @phases })
      end
    end
  end

  private

  def phase_params
    params.require(:phase).permit(:name, :description, :parent_id)
  end
end
