//Initial load of page
$(document).ready(sizeContent);

//Every resize of window
$(window).resize(sizeContent);

//Dynamically assign height
function sizeContent() {
    var newHeightRight = $("html").height() - 145;
    $(".diva-outer").css("height", newHeightRight);
    var newHeightLeft = $("html").height() - 50;
    $("#left").css("height", newHeightLeft);
}