document.addEventListener('DOMContentLoaded', function ()
        {
            var xml_id = $('h1').attr('id');
            var ms_id = xml_id.match(/\d+/g);
            var digitized = $('h1').attr('class');
            if (digitized == "digitized" || digitized == "digitized_partly") {
            let diva = new Diva('diva-wrapper', {
                objectData: "../iiif/" + ms_id + "/manifest.json",
                enableAutoTitle: false,
            });
        }
        }, false)