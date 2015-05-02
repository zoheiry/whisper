class ConversationsController < ApplicationController

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
