xquery version "3.1";
module namespace et = "http://example/trigger";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
declare namespace trigger = "http://exist-db.org/xquery/trigger";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare option exist:serialize "method=xml media-type=text/xml indent=yes";

declare function trigger:after-update-document($uri as xs:anyURI) {
    let $collection := concat($config:app-root, "/stylesheets/templates/")
    let $template := doc(concat($collection, "/tei2html_template.xsl"))
    let $stylesheet := doc(concat($collection, "template2xsl_en.xsl"))
    let $result_doc := transform:transform($template, $stylesheet, ())
    return
    et:transform($collection, $result_doc)
};

declare function et:transform($collection as node(), $result_doc as node()){
    xmldb:store($collection, 'tei2html_test.xsl', $transformation)
};