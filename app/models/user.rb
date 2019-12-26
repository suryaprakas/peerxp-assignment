class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.from_omniauth(auth)
    # Creates a new user only if it doesn't exist
    where(email: auth.info.email).first_or_initialize do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.encrypted_password = "Welcome#1234"
      # Access_token is used to authenticate request made from the rails application to the google server
      user.google_token = auth.credentials.token
      # Refresh_token to request new access_token
      # Note: Refresh_token is only sent once during the first request
      refresh_token = auth.credentials.refresh_token
      user.google_refresh_token = refresh_token if refresh_token.present?
      debugger
      user.save!
    end
  end

  # Public: For generating saml key for a user.
  #
  # Returns cached string.
  def generate_saml_key
    saml_key = formulate_saml_key
    Rails.cache.write(saml_key, self.id, :expires_in => 86400)
    saml_key
  end

  def generate_api_key
    api_key = formulate_key
    # cached_key = User.cached_api_key(api_key)
    # auth_token = Rails.cache.read(cached_key)
    # break if auth_token.blank? || i == FrescoPlay::Settings[:authentication][:token_max_check_limit]
    # logger = ApplicationHelper.custom_logger("DuplicateKey.log")
    # logger.error("Duplicate api_key(#{api_key}) found for employee_id: #{self.employee_id}")
    # Rails.cache.delete(cached_key)
    # api_key = formulate_key
    # Write it into cache
    Rails.cache.write(User.cached_api_key(api_key),
     self.authentication_token,
      :expires_in => 86400)
    # Return the hash
    api_key
  end

  def self.cached_api_key(api_key)
    "api/#{api_key}"
  end

  def create_user(params)
    user = User.new(user_params)
    user.password = params[:password]
    user.encrypted_password = params[:password]
    user
  end

  private

  def formulate_saml_key
    str = OpenSSL::Digest::SHA256.digest("saml_#{SecureRandom.uuid}_#{self.id}_#{Time.now.to_i}")
    Base64.encode64(str).gsub(/[\s=]+/, "").tr('+/','-_')
  end

  def formulate_key
    str = OpenSSL::Digest::SHA256.digest("#{SecureRandom.uuid}_#{self.id}_#{Time.now.to_i}")
    Base64.encode64(str).gsub(/[\s=]+/, "").tr('+/','-_')
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

end
