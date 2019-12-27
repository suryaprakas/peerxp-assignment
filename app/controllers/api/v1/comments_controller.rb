class Api::V1::CommentsController < ApplicationController

    skip_before_action :verify_authenticity_token  
    
    swagger_controller :comments, 'Comments Management'

    swagger_api :index do
      summary 'Returns comment details'
      param :query, :id, :integer, :required, 'Comment Id'
    end

    def index
      @comment = Comment.where(id: params[:id]).first
      render :details, status: :ok
    end

    swagger_api :create do
      summary 'Create Comments'
      param :form, :'comment[title]', :string, :required, 'Title'
      param :form, :'comment[task_id]', :integer, :required, 'Task ID'
    end
  
    def create
      @comment = Comment.new(comment_params)
      if @comment.save!
        render :details, status: :created
      else
        render json: {errors: @comment.errors.messages}
      end
    end

    swagger_api :update do
      summary 'Update Comments'
      param :path, :id, :integer, :required, "Comment ID"
      param :form, :'comment[title]', :string, :required, 'Title'
      param :form, :'comment[task_id]', :integer, :required, 'Task ID'
    end
    
    def update
      @comment = Comment.find(params[:id])
      if @comment.update!(comment_params)
        render :details
      else
        render json: {errors: @comment.errors.messages}
      end
    end

    swagger_api :destroy do
      summary 'Delete Comment'
      param :path, :id, :integer, :required, 'Comment Id'
    end
  
    def destroy
      @comment = Comment.where(id: params[:id]).first.delete
      render json: { message: "Comment Deleted successfully"} , status: :ok
    end

    private

    def comment_params
      params.require(:comment).permit(:title, :task_id)
    end

end