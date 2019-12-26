class UserSessionsController < ApplicationController

  swagger_controller :user_sessions, 'Users Sessions'

  swagger_api :sign_up do
    summary 'Sign UP'
    param :form, :'user[email]', :string, :required, 'Email'
    param :form, :'user[first_name]', :string, :required, 'First name'
    param :form, :'user[last_name]', :string, :required, 'Last name'
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

  swagger_api :create do
    summary 'Sign in a user to the application and returns back authentication token'
    param :form, :'user[email]', :string, :required, 'Email'
    param :form, :'user[password]', :password, :required, 'Password'
    response :created
    response :unauthorized
  end
  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    render json: { api_key: resource.generate_api_key }, status: :created
  end

  swagger_api :destroy do
    summary 'Signout a user'
    response :ok
    response :unprocessable_entity
  end
  # DELETE /resource/sign_out
  def destroy
    Rails.cache.delete User.cached_api_key(request.env['HTTP_X_API_KEY'])
    head :ok
  end

  def googleAuth
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    user = User.from_omniauth(access_token)
    if user.present?
      saml_code = user.generate_saml_key
      status = :found
    else
      saml_code = "NULL"
      status = :not_found
    end

    redirect_url = "http://localhost:3000/auth/saml/callback"
    redirect_to("#{redirect_url}?saml_code=#{saml_code}", status: status)
  end
end