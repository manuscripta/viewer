xquery version "3.1";

declare namespace editor="http://www.manuscripta.se/xquery/editor";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
import module namespace functx="http://www.functx.com";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $namespace := "http://www.manuscripta.se/xquery/editor";


declare function editor:local-part($name as xs:string) as xs:string {
    tokenize($name, ':')[last()]
};

(: make a tei element or attribute with spcified $name (without prefix) :)
declare function editor:make-elem($name as xs:string) as node() {
    if (starts-with($name, '@')) then
        attribute { QName("http://www.tei-c.org/ns/1.0", editor:local-part(replace($name, '^@', ''))) } {}
    else
        element { QName("http://www.tei-c.org/ns/1.0", editor:local-part($name)) } {}
};

declare function editor:get-elem($root, $name) {
    if (starts-with($name, '@')) then
        $root/attribute()[node-name(.) eq QName("http://www.tei-c.org/ns/1.0", replace($name, '^@', ''))]
    else
        $root/*[node-name(.) eq QName("http://www.tei-c.org/ns/1.0", $name)]
};

declare function editor:get-or-create-elem($root, $name) {
    let $elem := editor:get-elem($root, $name)
    return if ($elem) then $elem
    else (update insert editor:make-elem($name) into $root, editor:get-elem($root, $name))
};

declare function editor:handle-data($root as node(), $data as map()) {
    for $name in $data?*
    return
        let $value := $data($name)
        return if ($name eq '#text') then
            update value $root with $value
        else if (starts-with($name, '@')) then
            update insert attribute {substring-after($name, '@')} {$value} into $root
        else
        let $elem :=
            if ($value instance of array(*)) then
                let $delete-old :=
                    if (editor:get-elem($root, $name)) then
                        update delete editor:get-elem($root, $name)
                    else ()
                let $insert-new :=
                    update insert (for $i in 1 to array:size($value)
                                    return editor:make-elem($name)) into $root
                return editor:get-elem($root, $name)
            else editor:get-or-create-elem($root, $name)
        
        (: Make non-array $value to an single item array for simpler handling below :)
        let $value := if ($value instance of array(*)) then $value else [ $value ] 
        
        (: Make sure the document shape is as expected :)
        let $_ := if (count($elem) ne array:size($value)) then
            error(xs:QName("editor:error"), "Ambigous update of document: the number of nodes selected ("||count($elem)||")\
for the path " || functx:path-to-node($root)||'/'||$name|| ' is different from the number of values ('||array:size($value)||') got from form input.', $data) else ()
        
        for $elem at $i in $elem
        let $value := array:get($value,$i)
        return (:if (not(empty($value))) then:)
        typeswitch($value)
        case map()
            return editor:handle-data($elem, $value)
        default
            return error(xs:QName("editor:error"), concat("Data with name '", $name, "' had a value of unexpected type: "), $value)
        (:else ():) (: JSON data value was 'null' :)
        
};

let $login := xmldb:login($config:data-root, 'admin', '')

let $id := request:get-parameter('id', '')
let $id := if ($id) then $id else error(xs:QName("editor:error"), 'parameter "id" not found')

let $data := parse-json(util:binary-to-string(request:get-data()))

let $doc := doc(concat($config:data-root, "/msDescs/", $id, '.xml'))

(: store in a separate document while we dont have a better safety system implemented (e.g. versioning) :)
let $created := xmldb:create-collection($config:data-root , "/msDescs-stored/")
let $store := xmldb:store($config:data-root || "/msDescs-stored/", $id || '.xml', $doc)
let $doc := doc(concat($config:data-root, "/msDescs-stored/", $id, '.xml'))

return
util:exclusive-lock($doc, 
<result>{(
    editor:handle-data($doc/root(), $data)
)}</result>)

