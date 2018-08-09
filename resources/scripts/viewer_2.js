$(document).ready(function () {
    /* Get the @id from h1 to automatically generate url:s to objectData and ImageDir */
    var xml_id = $('h1').attr('id');
    var ms_id = xml_id.match(/\d+/g);  
    
    var digitized = $('h1').attr('class');
    if (digitized == "digitized" || digitized == "digitized_partly") {
    $(function() {
            Mirador({
            "id": "viewer",
            "mainMenuSettings" : {
            'show' : false
            },
            "buildPath" : "../resources/scripts/mirador/",
            "data": [            
                {"manifestUri": "https://test.manuscripta.se/iiif/" + ms_id + "/manifest.json",
                "location": "Manuscripta.se"}
            ],
            "windowObjects": [
            {
            "loadedManifest": "https://test.manuscripta.se/iiif/" + ms_id + "/manifest.json",
            "canvasID": "https://test.manuscripta.se/iiif/"  + ms_id + "/canvas/c-7",            
            "viewType" : "ImageView",
            "displayLayout": false,
            "bottomPanel" : false,
            "bottomPanelVisible": false,
            "sidePanel" : false,
            "annotationLayer" : false
            }
            ]
            });
            });
    }
});

//Initial load of page
$(document).ready(sizeContent);

//Every resize of window
$(window).resize(sizeContent);

//Dynamically assign height
function sizeContent() {
    var newHeightRight = $("html").height() - 107;
    $(".diva-outer").css("height", newHeightRight);
    var newHeightLeft = $("html").height() - 50;
    $(".col-lg-6").css("height", newHeightLeft);
}

// Generate links for images
var facs = document.getElementsByClassName("facsimile");
var facsimile = function () {
var index = $(this).attr("data-image-id");
    $('#viewer').data('diva').gotoPageByIndex(index);
}
for (var i = 0; i < facs.length; i++) {
    facs[i].addEventListener("click", facsimile);
}

// split.js
Split(['#ms-desc', '#viewer'], {
                sizes: [50, 50],
                minSize: 10
});
