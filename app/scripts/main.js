$(document).ready(function() {
  $('.btn-shortcut-menu').click(function(e) {
    e.preventDefault();
    $('.workspace').toggleClass('menu-open');
    if($('.workspace').hasClass('side-view-open')) {
      $('.workspace').removeClass('menu-open side-view-open');
    }
  });

  $('.navigation-item a').click(function(e) {
    e.preventDefault();
    $('.workspace').toggleClass('side-view-open');
  });

  $('.side-view-option-icon').click(function(e) {
    e.preventDefault();
    $('.side-view-option').toggleClass('side-view-option-open');
  });

  videojs($('video').get(0))

  $('.fullscreen').click(function (e) {
    e.preventDefault();
    if (screenfull.enabled) {
      screenfull.request();
    }
  })
});