class HomeController < ApplicationController

	def index
		@user = {username: "Zoheiry"}		
		# flash[:alert] = "Here.."
	end
	
end
