xquery version "3.1";
module namespace et = "http://example/trigger";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
declare namespace trigger = "http://exist-db.org/xquery/trigger";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option output:method "json";
declare option output:indent "yes";
declare option output:media-type "application/json";



declare function trigger:after-update-document($uri as xs:anyURI) {    
    let $iiif_collection := doc(concat($config:app-root, "/", "iiif_test123.json"))    
    let $result_doc := map {
    "@context": "http://iiif.io/api/presentation/2/context.json",
    "@id": "https://www.manuscripta.se/iiif/collection",
    "@type": "sc:Collection",
    "viewingHint": "top",
    "label": "Manuscripta.se IIIF Collections",
    "description": "Collection of IIIF manifests from Manuscripta.se",
    "manifests": 
    for $msDescs in collection($config:data-root || "/msDescs")
            where $msDescs//tei:facsimile
            let $id := substring-after($msDescs//tei:TEI/@xml:id, 'ms-')
            let $label := $msDescs//tei:titleStmt/tei:title/text()
            order by $id
            return
                map {
                    "@id": concat("https://dev.manuscripta.se/iiif/",$id,"/manifest.json"),
                    "label": $label,
                    "@type": "sc:Manifest"
                    
                }
    
}
return 
xmldb:store($config:data-root, $iiif_collection, $result_doc)
};    
