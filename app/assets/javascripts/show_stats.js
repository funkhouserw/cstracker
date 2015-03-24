function detectBlocked() {
    if ($('#abg ins').filter(':visible').length == 0 || $('#abg ins').filter(':hidden').length > 0) {
      $("#abg_header").remove();
      $("#abg").remove();
    }
}

$(document).ready(function () {
  setTimeout(detectBlocked, 50);
});
