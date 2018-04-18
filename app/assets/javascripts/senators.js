var sen = () => {

$('.call').click(() => {
  $('.call_modal').modal('show');
  console.log('senate');
})

$('.schedule').click(() => {
  $('.schedule_modal').modal('show');
  console.log('senate');
})

};

$(document).ready(sen);
$(document).on('turbolinks:load', sen);
$(window).bind('page:change', sen)
