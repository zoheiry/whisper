class ConversationsController < ApplicationController
	before_filter :authenticate_user!, only:[:conversation]
	before_filter :check_relation, only:[:conversation]

	# GET /c/:channel_name
	def conversation
		@user = current_user
		@other_user = User.where(username: params[:channel_name])[0]
	end

	# GET /k/:public_key
	def key
		current_user.public_key = params[:public_key]
		current_user.save
		render :json => {status: "Keys added successfully, but please keep your private key safe, as you will be aske for it upon sign up"}
	end

	# GET /a/:user_id
	def add_friend
		# raise Exception params
		u1_id = current_user.id
		u2_username = params[:username]
		u2 = User.where(username: u2_username)[0]
		u2_id = u2.id
		puts "U1 id" + u1_id.to_s
		puts "U2 id" + u2_id.to_s
		if !(Conversation.where(u1_id: u1_id, u2_id: u2_id).length == 0)
			redirect_to "/", alert: "Failed to add user.." and return
		
		else
			u1_pk = current_user.public_key
			u2_pk = u2.public_key

			c = Conversation.new

			c.u1_id = u1_id
			c.u2_id = u2_id
			c.u1_pk = u1_pk
			c.u2_pk = u2_pk
			if c.save
				redirect_to "/c/#{c.channel_name}", notice: "Successfully added #{u2.username}!"
			else
				redirect_to "/", alert: "Failed to add user.."
			end
		end

	end

	# def subscribe
	# 	pubnub = Pubnub.new(
	# 		:publish_key   => 'pub-c-986edf90-6086-4572-b43b-4ac6883ca4e6',
	# 		:subscribe_key => 'sub-c-69ec4ef8-bbfd-11e3-b6e0-02ee2ddab7fe'
	# 	)
	# 	pubnub.subscribe(
	# 		:channel  => params[:channel_name]
	# 	) { |data| puts data.msg }
	# 	render :json => {status: "Successfully subscribed to channel " + params[:channel_name].to_s}
	# end

	# def publish
	# 	pubnub = Pubnub.new(
	# 		:publish_key   => 'pub-c-986edf90-6086-4572-b43b-4ac6883ca4e6',
	# 		:subscribe_key => 'sub-c-69ec4ef8-bbfd-11e3-b6e0-02ee2ddab7fe'
	# 	)
	# 	pubnub.publish(
	# 		:channel  => params[:channel_name],
	# 		:message => params[:message],
	# 	) { |data| puts data.response }
	# 	render :json => {status: "published " + params[:message].to_s + " to channel " + params[:channel_name].to_s}
	# end
	def check_relation
		@u1_id = current_user.id
		@u2_id
		@u2 = User.where(username: params[:channel_name])[0]
		if @u2
			@u2_id = @u2.id
		else
			redirect_to "/", alert: "This user does not exist" and return
		end
		@c1 = Conversation.where(u1_id: @u1_id, u2_id: @u2_id)
		@c2 = Conversation.where(u1_id: @u2_id, u2_id: @u1_id)
		@c = @c1 + @c2
		if(@c.length > 0)
			return true
		else
			redirect_to "/", alert: "You are not friends with this user" and return
		end
	end
end
