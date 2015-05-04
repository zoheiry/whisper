class HomeController < ApplicationController
	before_filter :authenticate_user!
	before_filter :is_authified

	def index
		if current_user.sign_in_count == 1
			current_user.update_attributes(sign_in_count: 2)
			redirect_to '/your_keys'
		end
		@user = current_user	
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
		@group_chats = GroupChat.where(u_id: current_user.id)
		#showing pending requests
		@pending_requests = Pending.where(u2_id: current_user.id)
		@pending_friends = []
		@pending_requests.each do |pr|
			@pending_friends.push(User.find(pr.u1_id))
		end
	end
	
	def keys
		
	end

	def create_group
		names = params[:members].split("*")
		names_string = ""
		member_ids = ""
		names.each_with_index do |n, i|
			unless i == (names.length - 1)
				names_string += n + ", "
			else
				names_string += n	
			end
			member_ids += ((User.where(username: n)[0]).id).to_s
		end
		names.each do |n| 
			u = User.where(username: n)[0]
			GroupChat.create(u_id: u.id, group_id: member_ids, group_name: names_string)
		end

		render :json => {status: "created group"}
	end

	def accept
		id1 = params["id1"]
		id2 = params["id2"]
		Pending.where(u1_id: id1, u2_id: id2).destroy_all
		c1 = Conversation.new(u1_id: id1, u2_id: id2, 
			u1_pk: User.find(id1).public_key, u2_pk: User.find(id2).public_key)

		if c1.save
			redirect_to root_path, notice: "you are now friends with 
			#{User.find(id1).username}" 
		else
			redirect_to root_path, notice: "Something wrong happend"
		end
	end
end
