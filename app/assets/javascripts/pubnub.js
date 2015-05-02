var PUBNUB_message = PUBNUB.init({
    publish_key: 'pub-c-986edf90-6086-4572-b43b-4ac6883ca4e6',
    subscribe_key: 'sub-c-69ec4ef8-bbfd-11e3-b6e0-02ee2ddab7fe'
});

function subscribe() {
	channel_name = $("#channel_name").text();
	PUBNUB_message.subscribe({
	    channel: channel_name,
	    message: function(m){subscribeCallback(m)}
	});
	console.log(channel_name)
}

function publish(message) {
	channel_name = $("#channel_name").text();
	console.log("going to encrypt this " + message);
	var encryped_message = encrypt(message, $("#receiver_pub_key").text());
	PUBNUB_message.publish({
		channel: channel_name,
		message: encryped_message
	});
}

function subscribeCallback(m) {
	console.log("going to decrypt this " + m);
	var decrypted_message = decrypt(m, localStorage.getItem("private_key"));
	console.log(decrypted_message);
}