xquery version "3.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";


<result> {
    for $c in collection($config:data-root || "/msDescs")//tei:country
    group by $t := $c/text()
    order by $t
    return $c[1]
}</result>
