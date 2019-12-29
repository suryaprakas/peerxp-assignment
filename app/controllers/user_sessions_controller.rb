class UserSessionsController < Devise::SessionsController

  skip_before_action :authenticate_user_token!, :authenticate_user!, only: [:create, :sign_up, :saml_signin]
  skip_before_action :verify_authenticity_token  
  swagger_controller :user_sessions, 'Users Sessions'

  swagger_api :sign_up do
    summary 'Sign UP'
    param :form, :'user[email]', :string, :required, 'Email'
    param :form, :'user[first_name]', :string, :required, 'First name'
    param :form, :'user[last_name]', :string, :required, 'Last name'
    param :form, :'user[password]', :password, :required, 'Password'
  end

  def sign_up
    @user = User.new(user_params)
    @user.password = params[:user][:password]
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

  swagger_api :saml_signin do
    summary 'Pass the saml code to sign_in'
    param :form, :code, :string, :required, 'Saml code'
    response :ok
    response :forbidden
  end

  def saml_signin
    code = params[:code]
    status, result = User.from_saml_code(code)
    if status
      sign_in(result, result)
      render json: { api_key: result.generate_api_key }, status: :created
    else
      if result.present?
        message = "#{result['error']} - #{result['error_description']}"
        render json: { error: message }, status: :bad_request
      else
        render json: { error: _('views.exceptions.not_found') }, status: :unauthorized
      end
    end
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

    redirect_url = "http://localhost:3000/auth/saml/"
    redirect_to("#{redirect_url}?saml_code=#{saml_code}", status: status)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end