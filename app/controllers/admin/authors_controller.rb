class Admin::AuthorsController < ApplicationController
  before_action :require_admin, only: [:index]
  before_action :set_author, except: [:create, :new, :index ]
  before_action :ensure_author_access, only: [:edit, :destroy, :update, :show]
  # create public author controller & route to access `show`

  def create
    @author = current_user.authors.build(author_params)

    if @author.save
      redirect_to admin_author_path(@author), notice: "Author profile successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def edit
  end

  def index
    @authors = Author.includes(:user).all
  end

  def show
    @resources = @author.resources
    # include phase information? (eager load)
  end

  def new
    @author = Author.new
  end

  def update
    if @author&.update(author_params)
      redirect_to admin_author_path(@author), notice: "Author profile successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_author
      if current_user.admin?
        @author = Author.find(params[:id])
      else
        @author = current_user.authors.find_by(id: params[:id])
      end
    end

    def author_params
      params.require(:author).permit(:pen_name, :information, :primary)
    end

    def ensure_author_access
      unless @author.manageable_by?(current_user)
        redirect_to root_path, alert: "Access Denied."
      end
    end
end
