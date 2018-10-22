xquery version "3.0";
let $input := doc('/db/apps/manuscripta-dev/data/msDescs/100021.xml')
let $xsl := doc('/db/apps/manuscripta-dev/stylesheets/tei2iiif.xsl')
let $xml2html := transform:transform($input, $xsl, ())
let $stored := xmldb:store('/db/apps/manuscripta-dev/', 'test_iiif.json', $xml2html, 'application/json')
return
$stored
