/* Get the url for Google books or Archive.org from @id in h3  */
var url = $('h3').attr('id');
/* Check for a span with @id='startPage' */
if (document.getElementById('startPage')) {
    var startPage = document.getElementById('startPage').innerHTML;
}
/* Google books viewer */
if (url.startsWith('https://books.google.se/books?id=')) {
    var googleID = url.replace('https://books.google.se/books?id=', '');
    var viewer = null;
    google.books.load();
    
    /* Called when the Google API is loaded. Here we instantiate the
     * viewer for the desired book.
     */
    function initialize() {
        var viewerCanvas = document.getElementById('viewerCanvas');
        viewer = new google.books.DefaultViewer(viewerCanvas);
        viewer.load(googleID, viewerLoadFail, viewerLoadSuccess);
    }
    
    /* Called if the book could not load successfully
     */
    function viewerLoadFail() {
        document.getElementById('viewerCanvas').style.display = 'none';
    }
    function viewerLoadSuccess() {
        if (! viewer) return;
        viewer.goToPage(startPage);
    }
    
    /* Load the book as soon as the Google AJAX API is ready
     */
    google.books.setOnLoadCallback(initialize);
}
/* Archive.org with diva.js viewer */
if (url.startsWith('https://archive.org/details/')) {
    var archiveID = url.replace('https://archive.org/details/', '');
    $('#viewerCanvas').diva({
        objectData: "https://iiif.archivelab.org/iiif/" + archiveID + "/manifest.json",
        viewerWidthPadding: 0,
        goDirectlyTo: startPage,
        enableAutoWidth: false,
        enableAutoHeight: false,
        fixedHeightGrid: true,
        enableFilename: false,
        minZoomLevel: 0,
        zoomLevel: 2,
        pagesPerRow: 2,
        maxPagesPerRow: 10,
        verticallyOriented: true,
        inFullscreen: false,
        inGrid: false,
        enableLinkIcon: false,
        enableAutoTitle: false,
        enableDownload: true,
        blockMobileMove: false
    });
}
else {
    null
}

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

// split.js
Split(['#bibl', '#viewerCanvas'], {
                sizes: [50, 50],
                minSize: 10
});