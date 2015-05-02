var PUBNUB_message = PUBNUB.init({
    publish_key: 'pub-c-986edf90-6086-4572-b43b-4ac6883ca4e6',
    subscribe_key: 'sub-c-69ec4ef8-bbfd-11e3-b6e0-02ee2ddab7fe'
});

function subscribe(channel_name) {
	PUBNUB_message.subscribe({
	    channel: channel_name,
	    message: function(m){subscribeCallback(m)}
	});
}

function publish(message, channel_name) {
	PUBNUB_message.publish({
		channel: channel_name,
		message: message
	});
}

function subscribeCallback(m) {
	console.log(m);
}