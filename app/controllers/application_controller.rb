class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private 

  def after_sign_up_path_for(resource)
    foods_path
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

  def after_sign_in_path_for(resource)
    foods_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
