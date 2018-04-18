var main = () => {
  $("div.ui.three.column.grid").find("img").each(function () {
    let height = $(this).height();
    if (height >= 425) {
      let offset = ((height - 425) / 3) * -1
      if (offset < -10) {
        $(this).css("margin-top", offset)
      };
    } else {
      $(this).css("height", "100%");
      $(this).css("width", "initial");
      let width = $(this).width();
      if (width >= 357) {
        let offset = ((width - 357) / 3) * -1
        if (offset < -10) {
          $(this).css("margin-left", offset)
        }
      } else {
        let offset = ((357 - width) * -1)
        $(this).css("margin-left", offset)
      }
    }
  });

  $('.call_rep').click(() => {
    $('.representative_call_modal').modal('show');
    console.log('here');
  })

  $('.schedule_rep').click(() => {
    $('.representative_schedule_modal').modal('show');
    console.log('here');
  })

  $('.call_sen_junior').click(() => {
    $('.senator_call_modal_junior').modal('show');
    console.log('here');
  })

  $('.schedule_sen_junior').click(() => {
    $('.senator_schedule_modal_junior').modal('show');
    console.log('here');
  })

  $('.call_sen_senior').click(() => {
    $('.senator_call_modal_senior').modal('show');
    console.log('here');
  })

  $('.schedule_sen_senior').click(() => {
    $('.senator_schedule_modal_senior').modal('show');
    console.log('here');
  })

};
$(document).ready(main);
$(document).on('turbolinks:load', main);
$(window).bind('page:change', main)
