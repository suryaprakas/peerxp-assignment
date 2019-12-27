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
      param :form, :'project[user_id]', :string, :required, 'User id who creates the project'
    end
  
    def create
      @project = Project.new(project_params)
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
      param :form, :'project[user_id]', :string, :required, 'User id who creates the project'
    end
    
    def update
      @project = Project.find(params[:id])
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

    private

    def project_params
      params.require(:project).permit(:name, :description, :user_id)
    end

end