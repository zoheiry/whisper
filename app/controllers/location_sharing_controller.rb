class LocationSharingController < ApplicationController
	
	def index
		#for development purposes
		#debugger
		if Rails.env.development?
     		env['REMOTE_ADDR'] = "71.212.123.5"
    	end
		@location = request.location.address
	end
end
