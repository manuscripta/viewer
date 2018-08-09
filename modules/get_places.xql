xquery version "3.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

let $s := lower-case(request:get-parameter('s', ''))
let $searchInId := request:get-parameter('searchInId', 'false')
(:let $places := doc($config:data-root || "/authority_files/places.xml")//tei:listPlace/tei:place:)
let $places := collection($config:data-root || "/id/")//tei:listPlace/tei:place
return
    <result>{
        if ($s) then
            $places[contains(lower-case(tei:placeName), $s) or ($searchInId and contains(lower-case(@xml:id), $s))]
        else
            $places
    }</result>
