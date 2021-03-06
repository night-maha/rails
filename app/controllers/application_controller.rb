class ApplicationController < ActionController::Base

  #protect_from_forgery with: :exception
  #protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected


  def configure_permitted_parameters
    added_attrs = [:student_id, :name, :sex, :birthday, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: [:student, :student_id, :name, :sex, :birthday, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_in, keys: [:student, :student_id, :name, :sex, :birthday, :password_confirmation]

    # Rails.logger.debug "\n\n #{params}"
  end

  def after_sign_in_path_for(resource)
    '/users/show_record'
  end
  
end
