xquery version "3.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
declare namespace rng="http://relaxng.org/ns/structure/1.0";
declare namespace a="http://relaxng.org/ns/compatibility/annotations/1.0";
declare namespace tei="http://www.tei-c.org/ns/1.0";

let $s := lower-case(request:get-parameter('s', ''))
let $doc := doc($config:data-root || "/schemas/manuscripta.rng")
let $type := request:get-parameter('type', '')

let $items :=

switch($type)
case 'institution' return
    for $item in $doc//rng:element[@name='institution']/rng:choice/rng:value/text()
    return <item>{$item}</item>
case 'repository' return
    for $item in $doc//rng:element[@name='repository']/rng:choice/rng:value/text()
    return <item>{$item}</item>
case 'publisher' return
    for $item in $doc//rng:element[@name='publisher']/rng:choice/rng:value/text()
    return <item>{$item}</item>
case 'xmllang' return
    for $item in $doc//rng:define[@name='att.global.attribute.xmllang']//rng:attribute[@name="xml:lang"]/rng:choice/rng:value
    return <item name="{$item/following-sibling::a:documentation[1]/text()}" value="{$item/text()}"/>

default return error(QName("", "error"), "Invalid 'type' parameter: "||$type)

let $filtered :=
    if ($s) then $items[contains(lower-case(.), $s)]
    else $items

return
    <result>{$filtered}</result>

