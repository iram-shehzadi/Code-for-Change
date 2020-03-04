class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_project, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      sql_query = "name ILIKE :query \
      OR project_description ILIKE :query \
      OR location ILIKE :query \
      OR category @@ :query"
      @projects = Project.where(sql_query, query: "%#{params[:query]}%")
    else
      @projects = Project.all
    end
  end

  def show
    @projects = Project.geocoded
     @markers = [
      {
        lat: @project.latitude,
        lng: @project.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { project: @project }),
        image_url: @project.photo.present? ? @project.photo.service_url : 'https://kitt.lewagon.com/placeholder/cities/random'
      }
    ]
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
  end

  def edit
  end

  def update
    @project.update(project_params)
		redirect_to project_path(@project)
  end

  def destroy
    @project.destroy
		redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:name, :category, :project_description, :photo)
  end

  def find_project
    @project = Project.find(params[:id])
  end
end
