require 'authy'

class Users::RegistrationsController < Devise::RegistrationsController

  Authy.api_key = 'I0FWtcDWxxx6HYDmGc8G81J9szPhndgc'
  Authy.api_uri = 'https://api.authy.com/'

# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    # raise Exception "42@DC"
    authy = Authy::API.register_user(
      :email        =>  resource.email,
      :cellphone    =>  resource.mobile_number,
      :country_code =>  "20"
      )

    if authy.ok?
    # raise Exception authy

      resource.authy_id = authy.id # this will give you the user authy id to store it in your database
      resource.update_attributes(authy_id: authy.id)
      # redirect_to "/your_keys"
      # resource.save
    else
      authy.errors # this will return an error hash
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
    redirect_to "/your_keys"
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
