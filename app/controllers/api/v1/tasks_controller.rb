class Api::V1::TasksController < ApplicationController

    skip_before_action :verify_authenticity_token  
    
    swagger_controller :tasks, 'Tasks Management'

    swagger_api :index do
      summary 'Returns tasks details'
      param :query, :id, :integer, :required, 'Task Id'
    end

    def index
      @task = Task.where(id: params[:id]).first
      render :details, status: :ok
    end

    swagger_api :create do
      summary 'Create Tasks'
      param :form, :'task[project_id]', :integer, :required, 'Under which project task to be created'
      param :form, :'task[name]', :string, :required, 'Name'
      param :form, :'task[description]', :string, :optional, 'Description'
      param_list :form, :'task[priority]', :string, :optional, 'Priority', Task::Priority::ALL
      param :form, :'task[dead_line]', :date, :required, 'DeadLine for the task'
    end
  
    def create
      @task = Task.new(task_params)
      @task.status = Task::Status::FRESH
      if @task.save!
        render :details, status: :created
      else
        render json: {errors: @task.errors.messages}
      end
    end

    swagger_api :update do
      summary 'Update Tasks'
      param :path, :id, :integer, :required, "task ID"
      param :form, :'task[name]', :string, :required, 'Name'
      param :form, :'task[description]', :string, :optional, 'Description'
      param_list :form, :'task[priority]', :string, :optional, 'Priority', Task::Priority::ALL
      param_list :form, :'task[status]', :string, :optional, 'Priority', Task::Status::ALL
      param :form, :'task[dead_line]', :date, :required, 'DeadLine for the task'
    end
    
    def update
      @task = Task.find(params[:id])
      @task.status = params[:tasks][:status] if params[:tasks][:status].present?
      if @task.update!(task_params)
        render :details
      else
        render json: {errors: @task.errors.messages}
      end
    end

    swagger_api :destroy do
      summary 'Delete Task'
      param :path, :id, :integer, :required, 'Task Id'
    end
  
    def destroy
      @task = Task.where(id: params[:id]).first.delete
      render json: { message: "Task Deleted successfully"} , status: :ok
    end

    private

    def task_params
      params.require(:task).permit(:name, :description, :priority, :dead_line, :project_id)
    end

end