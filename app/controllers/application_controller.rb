class ApplicationController < ActionController::Base

	before_action :configure_devise_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected 
  
  def configure_devise_permitted_parameters
    registration_params = [:full_name, :email, :password, :password_confirmation]

    devise_parameter_sanitizer.for(:sign_up) << [ :username, :mobile_number ]

  end

  def is_authified
		if session[:autify] != "true"
			redirect_to "/two-step"
		end
	end
end
