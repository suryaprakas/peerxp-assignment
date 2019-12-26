class Api::V1::UsersController < ApplicationController
    swagger_controller :users, 'Users Manager'

    swagger_api :list_trainer do
      summary 'Returns all posts'
      notes 'Notes...'
    end

    def list_trainer
      render json: {message: "posts"}, status: :ok
    end

    swagger_api :sign_up do
      summary 'Sign UP'
      param :form, :'user[email]', :string, :required, 'Email'
      param :form, :'user[first_name]', :string, :required, 'Email'
      param :form, :'user[last_name]', :string, :required, 'Email'
      param :form, :'user[password]', :password, :required, 'Password'
    end
  
    def sign_up
      @user = User.create_user(params)
      if @user.save!
        render json: { user_details: @user}, status: :created
      else
        render json: {errors: @user.errors.messages}
      end
    end
end