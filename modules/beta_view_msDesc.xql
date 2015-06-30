xquery version "3.0";

module namespace beta_view="http://www.manuscripta.se/xquery/beta_view";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
import module namespace dq="http://exist-db.org/xquery/documentation/search" at "dq_search.xql";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

declare function beta_view:view-msDesc-html($model as map(*)) {
    transform:transform($model("doc"), doc('../data/stylesheets/tei2html.xsl'),() )
};

declare %templates:default("field", "all")
function beta_view:get-msDesc($node as node(), $model as map(*), $q as xs:string?, $doc as xs:string?, $field as xs:string){
   let $doc := request:get-parameter('id', '')
   let $path := $config:data-root || "/msDescs/" || $doc
   return
        if (exists($doc) and doc-available($path)) then
            let $context := doc($path)
            let $data :=
                if ($q) then
                    dq:do-query($context, $q, $field)
                else
                    $context
            return                
                <div class="container-msdesc col-xs-12 col-sm-12 col-md-6 col-lg-6">
                    {beta_view:view-msDesc-html(map { "doc" := util:expand($data/*, "add-exist-id=all") })}                                
                </div>                
        else
            <p>Document not found: {$path}</p>   
};