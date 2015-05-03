var PUBNUB_message = PUBNUB.init({
    publish_key: 'pub-c-986edf90-6086-4572-b43b-4ac6883ca4e6',
    subscribe_key: 'sub-c-69ec4ef8-bbfd-11e3-b6e0-02ee2ddab7fe'
});

function subscribe() {
	channel_name = $("#subscribe_channel").text();
	PUBNUB_message.subscribe({
	    channel: channel_name,
	    message: function(m){subscribeCallback(m)}
	});
	console.log(channel_name)
}

function publish(message) {
	var message_html = "<div class='clearfix'><div class='single-message sender'>" + message + "</div></div>"
	$(".messages-container").append(message_html);
	channel_name = $("#publish_channel").text();
	console.log("going to encrypt this " + message);
	console.log($("#receiver_pub_key").text());
	var encryped_message = encrypt(message, $("#receiver_pub_key").text());
	PUBNUB_message.publish({
		channel: channel_name,
		message: encryped_message
	});
	$(".messages-container").animate({
		scrollTop: $(".single-message").last().offset().top
	});
	var count = $(".single-message").length
	localStorage.setItem(channel_name + '-message-' + count, message);
}

function subscribeCallback(m) {
	console.log("going to decrypt this " + m);
	channel_name = $("#publish_channel").text();
	var decrypted_message = decrypt(m, localStorage.getItem("private_key"));
	var message_html = "<div class='clearfix'><div class='single-message receiver'>" + decrypted_message + "</div></div>"
	$(".messages-container").append(message_html);
	$(".messages-container").animate({
		scrollTop: $(".single-message").last().offset().top
	});
	var count = $(".single-message").length
	localStorage.setItem(channel_name + '-message-' + count, decrypted_message);
}