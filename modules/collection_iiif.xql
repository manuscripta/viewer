xquery version "3.1";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option output:method "json";
declare option output:indent "yes";
declare option output:media-type "application/json";

<output:root
    context="http://iiif.io/api/presentation/2/context.json"
    id="https://www.manuscripta.se/iiif/collection"
    type="sc:Collection">
    <output:label>Manuscripta.se IIIF Collections</output:label>
    <output:viewingHint>top</output:viewingHint>
    <output:description>Collection of IIIF manifests from Manuscripta.se</output:description>
    <output:manifests>
        {
            for $msDescs in collection($config:data-root || "/msDescs")
            where $msDescs//tei:facsimile
            let $id := substring-after($msDescs//tei:TEI/@xml:id, 'ms-')
            let $label := $msDescs//tei:titleStmt/tei:title/text()
            order by $id
            return
                <output:manifest
                    id="https://dev.manuscripta.se/iiif/{$id}/manifest.json"
                    type="sc:Manifest">
                    <output:label>{$label}</output:label>
                </output:manifest>
        }
    </output:manifests>
</output:root>