class Api::V1::ProjectsController < ApplicationController

    skip_before_action :verify_authenticity_token  
    
    swagger_controller :projects, 'Projects Management'

    swagger_api :index do
      summary 'Returns project details'
      param :query, :id, :integer, :required, 'Project Id'
    end

    def index
      @project = Project.where(id: params[:id]).first
      render :details, status: :ok
    end

    swagger_api :create do
      summary 'Create Projects'
      param :form, :'project[name]', :string, :required, 'Name'
      param :form, :'project[description]', :string, :optional, 'Description'
    end
  
    def create
      @project = Project.new(project_params)
      @project.user_id = current_user.id
      if @project.save!
        render :details, status: :created
      else
        render json: {errors: @project.errors.messages}
      end
    end

    swagger_api :update do
      summary 'Update Projects'
      param :path, :id, :integer, :required, "Project ID"
      param :form, :'project[name]', :string, :required, 'Name'
      param :form, :'project[description]', :string, :optional, 'Description'
    end
    
    def update
      @project = Project.find(params[:id])
      @project.user_id = current_user.id
      if @project.update!(project_params)
        render :details
      else
        render json: {errors: @project.errors.messages}
      end
    end

    swagger_api :destroy do
      summary 'Delete Project'
      param :path, :id, :integer, :required, 'Project Id'
    end
  
    def destroy
      @project = Project.where(id: params[:id]).first.delete
      render json: { message: "Project Deleted successfully"} , status: :ok
    end

    swagger_api :tasks do
      summary 'Tasks of the project'
      param :path, :id, :integer, :required, 'Project Id'
    end
  
    def tasks
      @project = Project.where(id: params[:id]).first
      if @project.user_id == current_user.id
        render :show , status: :ok
      else
        render json: {messages: "Unauthorized"}, status: :unauthorized
      end
    end

    private

    def project_params
      params.require(:project).permit(:name, :description)
    end

end