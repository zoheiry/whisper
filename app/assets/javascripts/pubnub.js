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
	if(channel_name[0] == "~") {
		//////////////////this is a group message////////////////
		var usernames = channel_name.replace('~', '');
		usernames = usernames.split(',');
		var public_keys = ($("#receiver_pub_key").text()).split('~');
		for(var i = 0; i < usernames.length; i++) {
			console.log("going to encrypt: " + message);
			console.log("With this public key: " + public_keys[i]);		
			var encryped_message = encrypt($("#channel_id").text() + "~" + $("#subscribe_channel").text() + ": " + message, public_keys[i]);
			PUBNUB_message.publish({
				channel: usernames[i],
				message: encryped_message
			});
		}
	}
	else {
		console.log("going to encrypt: " + message);
		console.log("With this public key: " + $("#receiver_pub_key").text());
		var encryped_message = encrypt($("#subscribe_channel").text() + "~" + message, $("#receiver_pub_key").text());
		PUBNUB_message.publish({
			channel: channel_name,
			message: encryped_message
		});
	}
	$(".messages-container").animate({
		scrollTop: $(".single-message").last().offset().top
	});

	localStorage.setItem('all_message_' + channel_name, localStorage["all_messages_" + channel_name] + "~" + channel_name + '^' + "sender^" + message);
}

function subscribeCallback(m) {
	console.log("going to decrypt this " + m);
	channel_name = $("#publish_channel").text();
	var decrypted_message = decrypt(m, localStorage.getItem("private_key"));
	if((decrypted_message.split('~')[0] == $("#publish_channel").text()) || (decrypted_message.split('~')[0] == $("#channel_id").text())) {
		decrypted_message = decrypted_message.split('~')[1];
		var message_html = "<div class='clearfix'><div class='single-message receiver'>" + decrypted_message + "</div></div>"
		$(".messages-container").append(message_html);
		$(".messages-container").animate({
			scrollTop: $(".single-message").last().offset().top
		});
			localStorage.setItem('all_messages_' + channel_name, localStorage["all_messages_" + channel_name] + "~" + channel_name + '^' + "sender^" + decrypted_message);
	}
	else {
		alert(decrypted_message.split('~')[0] + " is trying to contact you");
	}
}