require 'authy'

class AuthyController < ApplicationController

	Authy.api_key = 'I0FWtcDWxxx6HYDmGc8G81J9szPhndgc'
  Authy.api_uri = 'https://api.authy.com/'

  def two_step
    response = Authy::API.request_sms(:id => current_user.authy_id)

    if response.ok?
      flash[:notice] = "A message has been sent to 0#{current_user.mobile_number}"
    else
      puts response.errors
      flash[:alert] = "There seems to be a problem sending you the authorization token.."
    end
  end

  # POST /confirm
  def confirm
  	auth_code = params[:authy][:auth_code]
  	# raise auth_code

  	response = Authy::API.verify(:id => current_user.authy_id, :token => auth_code)

    if response.ok?
      redirect_to "/", notice: "Successfully confirmed!"
    else
      redirect_to "/two-step", alert: "You entered an invalid token, a new one has been sent out!"
    end

  end
end
