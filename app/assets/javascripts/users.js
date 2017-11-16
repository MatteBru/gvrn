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
};

$(document).ready(main);