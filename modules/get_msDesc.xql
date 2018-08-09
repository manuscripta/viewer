xquery version "3.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";


let $id := request:get-parameter('id', '')
let $subfolder := substring-before($id, '-')
let $path := concat($config:data-root, "/msDescs/", '/', $id, '.xml')
return doc($path)
