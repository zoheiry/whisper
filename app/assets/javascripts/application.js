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

$(document).ready(function() {
  if($("#keys-window").attr("data-view-name")) {
    genkey();
    public_key =  "Your public key: " + getPublicKey();
    private_key =  "Your private key: " + getPublicKey() + "(keep this key safe because you will need it)";

    $("#public_k").html(public_key);
    $("#private_k").html(private_key);

    $("#claim-key").attr("href", "/k/" + getPublicKey());
  }
});

$(document).on('click', '.menu_icon', function(){
	$(".menu-bar").toggleClass('hidden-menu');
});
