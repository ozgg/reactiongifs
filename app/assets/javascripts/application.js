// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-2.0.3.min
//= require jquery_ujs
//= require jquery.turbolinks
//= require jquery.clipboard
//= require_tree .

$(document).ready(function() {
    var copy_sel = $('.copy-to-clipboard');

    copy_sel.on('click', function(e) {
        e.preventDefault();
    });

    copy_sel.clipboard({
        path: '/swf/jquery.clipboard.swf',
        copy: function() {
            return $(this).data('text');
        }
    });
});
