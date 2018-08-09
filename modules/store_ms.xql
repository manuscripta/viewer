xquery version "3.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";

let $login := xmldb:login($config:data-root, 'admin', '')
let $data := request:get-data()
let $id := $data/@fileId
let $doc := $data/tei:TEI
let $created := xmldb:create-collection($config:data-root , "/msDescs-stored/")
let $store := xmldb:store($config:data-root || "/msDescs-stored/", $id || '.xml', $doc)
return ()
