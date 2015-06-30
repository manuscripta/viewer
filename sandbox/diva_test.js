$(document).ready(function() {
        $('#diva-wrapper').diva({
            iipServerURL: "http://probok.alvin-portal.org/cgi-bin/iipsrv.fcgi",
            objectData: "ut.json",
            imageDir: "/home/alvin/conv-service/outputImages/jp2/ca/Original",
            enableGridControls: "slider",
            enableZoomControls: "slider",
            minZoomLevel: 1,
            zoomLevel: 1,
            pagesPerRow: 4,
            verticallyOriented: true,
            inFullscreen: true,
            inGrid: true,
            enableAutoTitle: false,
            enableDownloadpdf: true,
            enableDownload: false,
            toolbarParentSelector: "#tool"
            // Other options can be set here as well
        });
    });