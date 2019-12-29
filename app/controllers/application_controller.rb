class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception, unless: -> { request.format.json? }
    # protect_from_forgery with: :null_session, unless: -> { request.format.json? }
  
    before_action :authenticate_user!, :authenticate_user_token!
    after_action :set_headers

  
    rescue_from CanCan::AccessDenied, with: :forbidden_access
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  
    def authenticate_user_token!
      unauthorized_access if current_user.blank?
    end
  
    def current_user
      @current_user ||= User.from_api_key(request.headers["X-Api-Key"], true)
    end
  
    def authenticate_user!
      request.headers["X-Api-Key"].present? ? authenticate_user_token! : authenticate_user_via_consumer_app!
    end
  
    private
  
    def unauthorized_access
      render_error_json("Authentication Failure", :unauthorized)
    end
  
    def invalid_parameter!(parameter_name)
      raise "Invalid Parameter"
    end
  
    def invalid_parameter(exception)
      render_error_json(exception.message, :bad_request)
    end
  
    def forbidden_access
      render_error_json('Forbidden', :forbidden)
    end
  
    def record_not_found
      render_error_json(_('views.exceptions.not_found'), :not_found)
    end
  
    def insufficient_details(message)
      render_error_json(message, :bad_request)
    end
  
    def render_error_json(message, status = :bad_request)
      render json: { error: message }, status: status
    end
  
    def set_headers
      if( request.headers['X-Api-Key'] != request.env['HTTP_X_API_KEY'] )
        logger = ApplicationHelper.custom_logger("mismatched_api_keys_#{Date.today.to_s}.log")
        logger.info(" #{request.headers['X-Api-Key']} :: #{request.env['HTTP_X_API_KEY']} :: #{current_user.try(:employee_id)}") 
      end  
      response.headers['X-Emp-Id'] = current_user.try(:employee_id) if current_user.present?
    end
  
end
