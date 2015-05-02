class HomeController < ApplicationController
	before_filter :authenticate_user!
	def index
		# if current_user.sign_in_count == 1
		# 	current_user.update_attributes(sign_in_count: 2)
		# 	redirect_to '/your_keys'
		# end
		@user = current_user	
		# flash[:alert] = "Here.."
		@friend_ids = []
		@friends = []
		@conversations1 = Conversation.where(u1_id: current_user.id)
		@conversations2 = Conversation.where(u2_id: current_user.id)
		@conversations1.each do |c|
			@friend_ids.push(c.u2_id)
		end
		@conversations2.each do |c|
			@friend_ids.push(c.u1_id)
		end
		@friend_ids.each do |f|
			@friends.push(User.find(f))
		end
	end
	
	def keys
		
	end

end
