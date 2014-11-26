$(function(){
  $('#featured').hide();
  $('#showcase').hide();
  $('.nav').find('a[href$="featured"]').hide();
  $('.nav').find('a[href$="showcase"]').hide();

  $('#grid form').submit(function(e){
    e.preventDefault();
    $('#featured').show();
    $('#showcase').show();
    $('.nav').find('a[href$="featured"]').show();
    $('.nav').find('a[href$="showcase"]').show();
  });
});