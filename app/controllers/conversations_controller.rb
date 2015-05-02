class ConversationsController < ApplicationController
	before_filter :authenticate_user!

	# GET /c/:channel_name
	def conversation
		@channel_name = params[:channel_name]
		@user = current_user
		@conversation = Conversation.where(channel_name: params[:channel_name])[0]
		@user_id
		if @conversation.u1_id == current_user.id
			@user_id = @conversation.u2_id
		else
			@user_id = @conversation.u1_id
		end
		@user = User.find(@user_id)
	end

	# GET /k/:public_key
	def key
		current_user.public_key = params[:public_key]
		current_user.save
		redirect_to "/", notice: "Claimed public key :)"
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
			cn = current_user.username + u2.username

			c.u1_id = u1_id
			c.u2_id = u2_id
			c.u1_pk = u1_pk
			c.u2_pk = u2_pk
			c.channel_name = cn

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

end
