class HomeController < ApplicationController

	def index
		if current_user.sign_in_count == 1
			current_user.update_attributes(sign_in_count: 2)
			redirect_to '/your_keys'
		end
		@user = {username: "Zoheiry"}		
		# flash[:alert] = "Here.."
	end
	
	def keys
		
	end

end
