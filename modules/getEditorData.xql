xquery version "3.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";


let $id := request:get-data('id', '')

let $doc := doc($config:data-root || "/msDescs/" || $id || '.xml')

return 

    <editorData>
        
    </editorData>
