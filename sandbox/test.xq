declare namespace tei="http://www.tei-c.org/ns/1.0";
for $mss in collection("/db/apps/manuscripta.se/data/msDescs")
let $title := $mss//tei:msItem/tei:title/text()
return
    <ms>
        <title>{$title}</title>
    </ms>