class Api::V1::UsersController < ApplicationController
    swagger_controller :users, 'Users Manager'

    # load_resource

    swagger_api :profile do
      summary 'Returns user profile'
      notes 'profile of the user'
    end

    def profile
      @user = current_user
      render :profile, status: :ok
    end

    # swagger_api :sign_up do
    #   summary 'Sign UP'
    #   param :form, :'user[email]', :string, :required, 'Email'
    #   param :form, :'user[first_name]', :string, :required, 'Email'
    #   param :form, :'user[last_name]', :string, :required, 'Email'
    #   param :form, :'user[password]', :password, :required, 'Password'
    # end
  
    # def sign_up
    #   @user = User.create_user(params)
    #   if @user.save!
    #     render json: { user_details: @user}, status: :created
    #   else
    #     render json: {errors: @user.errors.messages}
    #   end
    # end
end