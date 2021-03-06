// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var current_lng;
var current_lat;

$(document).on('click', '.send-location', function(){
  getLocation();
  setTimeout(function(){publish("^" + current_lat + "," + current_lat); }, 500);
});

$(document).on('click', '.menu_icon', function(){
	$(".menu-bar").toggleClass('hidden-menu');
});

$(document).on('click', '#add_friend_btn', function(){
  var input_field = $(this).parent().find('input')
  input_field.show();
  setTimeout(function(){
    input_field.css('right', '0');
  }, 10);
});

$(document).on('keyup', '#add_friend_input', function(e){
  if(e.keyCode == 13) {
    window.location = "/a/" + $("#add_friend_input").val();
  }
});

$(document).on('click', '#send_message', function(){
  if($(".reply-area").val().length == 0) {
    return;
  }
  publish($(".reply-area").val());
  $(".reply-area").val('');
});

$(document).on('keyup', '.reply-area', function(e){
  if(e.keyCode == 13) {
    if($(".reply-area").val().length == 0) {
      return;
    }
    publish($(".reply-area").val());
    $(".reply-area").val(''); 
  }
});

$(document).on('click', "#new_user input:submit", function(e){
  e.preventDefault();
  if($("#priv_key").length != 0) {
    if($("#priv_key").val().length == 0) {
      alert('please paste your private Key');
    }
    else {
      localStorage.setItem('private_key', $("#priv_key").val());
      $("#new_user").submit();
    }
  }
  else {
    localStorage.setItem('private_key', $("#priv_key").val());
    $("#new_user").submit();
  }
});

// (function () {
// var textFile = null,
//   makeTextFile = function (text) {
//     var data = new Blob([text], {type: 'text/plain'});

//     // If we are replacing a previously generated file we need to
//     // manually revoke the object URL to avoid memory leaks.
//     if (textFile !== null) {
//       window.URL.revokeObjectURL(textFile);
//     }

//     textFile = window.URL.createObjectURL(data);

//     return textFile;
//   };


//   var create = document.getElementById('create'),
//     textbox = document.getElementById('keys');

//   create.addEventListener('click', function () {
//     var link = document.getElementById('downloadlink');
//     link.href = makeTextFile(textbox.value);
//     link.style.display = 'block';
//   }, false);
// })();

function addFriend(username) {
  $.ajax({
    type: "post",
    url: "/a/" + username
  })
}
$(document).ready(function() {
  if($("#keys-window").attr("data-view-name")) {
    genkey();
    public_key =  "Your public key: " + getPublicKey();
    private_key =  "Your private key: " + getPrivateKey();

    $("#public_k").html(public_key);
    $("#private_k").html(private_key);

    $("#claim-key").attr("href", "/k/" + getPublicKey());
  }
});

$(document).on('click', '#claim-key', function(e){
  e.preventDefault();
  localStorage.setItem('private_key', getPrivateKey());
  $.ajax({
    type: "post",
    url: "/k/" + getPublicKey(),
    success:function(data){
      alert(data.status);
      window.location = "/";
    }
  })
});


function getFromStorage() {
  var all_messages = localStorage['all_messages_' + $("#publish_channel").text()];
  var messages_array = all_messages.split("~");
  for(var i = 0; i < messages_array.length; i++) {
    var single_message = messages_array[i];
    var data = single_message.split("^");
    var sender_or_receiver = data[1];
    var message = data[2];
    var message_html = "<div class='clearfix'><div class='single-message ' " + sender_or_receiver + ">" + message + "</div></div>"
    $(".messages-container").append(message_html);
  }
}

var visible = false;
$(document).on('click', '#group-chat', function(){
  if(visible) {
    visible = false;
    $(this).parent().find('.user-dropdown').slideUp();
  }
  else {
    visible = true;
    $(this).parent().find('.user-dropdown').slideDown();
  }
});

$(document).on('click', '.user-dropdown div', function(){
  $(this).toggleClass('selected');
});

$(document).on('click', '#create-group', function(){
  var names = $("#subscribe_channel").text() + "*";
  $(".user-dropdown div.selected").each(function(i){
    if(i == $(".user-dropdown div.selected").length - 1) {
      names += $(this).attr('username');
    }
    else {
      names += $(this).attr('username') + "*";
    }
  });
  console.log(names)
  visible = false;
  $(this).parent().slideUp();
  $.ajax({
    type: "post",
    url: '/create_group/' + names,
    success:function(data) {
      console.log(data);
      window.location = "/";
    }
  });
});


function createMap(container, lat, lng) {
  lat = parseFloat(lat);
  lng = parseFloat(lng);
  function initialize() {
    var mapCanvas = document.getElementById(container);
    var mapOptions = {
      center: new google.maps.LatLng(lat, lng),
      zoom: 8,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
    }
    var map = new google.maps.Map(mapCanvas, mapOptions);
  }
  google.maps.event.addDomListener(window, 'load', initialize);
  initialize()
}

function getLocation() {
  navigator.geolocation.getCurrentPosition(foundLocation);
  var lat;
  var lng;
  function foundLocation(position) {
    lat = position.coords.latitude;
    lng = position.coords.longitude;
    current_lat = lat;
    current_lng = lng;
  }
}