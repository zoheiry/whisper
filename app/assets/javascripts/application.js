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
    addFriend($("#add_friend_input").val());
  }
});

$(document).on('click', '#send_message', function(){
  publish($(".reply-area").val());
  $(".reply-area").val('');
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
    private_key =  "Your private key: " + getPrivateKey() + "(keep this key safe because you will need it)";

    $("#public_k").html(public_key);
    $("#private_k").html(private_key);

    $("#claim-key").attr("href", "/k/" + getPublicKey());
  }
});