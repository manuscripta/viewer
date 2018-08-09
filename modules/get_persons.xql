xquery version "3.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

let $s := lower-case(request:get-parameter('s', ''))
let $searchInId := request:get-parameter('searchInId', 'false')
(:let $persons := doc($config:data-root || "/authority_files/prosopography.xml")//tei:listPerson/tei:person:)
let $persons := collection($config:data-root || "/id/")//tei:listPerson/tei:person
return
    <result>{
        if ($s) then
            $persons[contains(lower-case(string-join(tei:persName//text(), ' ')), $s) or ($searchInId and contains(lower-case(@xml:id), $s))]
        else
            $persons
    }</result>
