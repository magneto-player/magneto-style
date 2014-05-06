$(document).ready(function() {
  $('.btn-shortcut-menu').click(function(e) {
    e.preventDefault();
    $('.workspace').toggleClass('menu-open');
    if($('.workspace').hasClass('side-view-open')) {
      $('.workspace').removeClass('menu-open side-view-open');
    }
  });

  $('.nav-item a').click(function(e) {
    e.preventDefault();
    $('.workspace').toggleClass('side-view-open');
  });

  videojs($('video').get(0))

  $('.fullscreen').click(function (e) {
    e.preventDefault();
    if (screenfull.enabled) {
      screenfull.request();
    }
  })

});