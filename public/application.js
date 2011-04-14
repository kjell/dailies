$(function() { 
  $("#pictures a").click(function() {
    img = $(this).children("img");
    already_exists = $("#photo img[src='" + img.attr("src") + "']");
    if(already_exists.length == 0) {
      img.clone().prependTo("#photo");
    } else {
      already_exists.prependTo("#photo");
    }
    
    return false;
  });
})