class ConversationsController < ApplicationController
	before_filter :authenticate_user!, only:[:conversation]
	before_filter :check_relation, only:[:conversation]
	before_filter :is_authified

	# GET /c/:channel_name
	def conversation
		@user = current_user
		if params[:channel_name].include? ","
			@is_group = true
			@channel_name = params[:channel_name]
			@members_string = @channel_name.delete(' ')
			@members_array = @members_string.split(',') - [current_user.username]
			@members_string = @members_array.join(',')
			@pub_keys = ""
			@members_array.each_with_index do |m, i|
				@u = User.where(username: m)[0]
				unless i == @members_array.length - 1
					@pub_keys += @u.public_key + "~"
				else
					@pub_keys += @u.public_key
				end					
					
			end
		else
			@other_user = User.where(username: params[:channel_name])[0]
		end
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
		if(!u2)
			redirect_to "/", alert: "User does not exist" and return
		end
		u2_id = u2.id
		puts "U1 id" + u1_id.to_s
		puts "U2 id" + u2_id.to_s
		if !(Conversation.where(u1_id: u1_id, u2_id: u2_id).length == 0)
			redirect_to "/", alert: "Failed to add user.." and return
		
		else
			if Pending.where(u1_id: u2_id, u2_id: current_user.id).length == 0
				Pending.create(u1_id: u1_id, u2_id: u2_id)
				redirect_to "/", notice: "Awaiting your friends reply" and return
			else
				u1_pk = current_user.public_key
				u2_pk = u2.public_key

				c = Conversation.new

				c.u1_id = u1_id
				c.u2_id = u2_id
				c.u1_pk = u1_pk
				c.u2_pk = u2_pk
				if c.save
					redirect_to "/", notice: "Successfully added #{u2.username}!"
				else
					redirect_to "/", alert: "Failed to add user.."
				end
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
		if params[:channel_name].include? ","
			return
		end
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
