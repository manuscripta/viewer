xquery version "3.0";

module namespace view="http://www.manuscripta.se/xquery/view";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

declare function view:get-msDesc($node as node(), $model as map(*)) as node(){    
    let $displayURI := request:get-parameter('id', '')
    let $rec := doc(concat($config:data-root, "/msDescs/", $displayURI))/tei:TEI    
    return
        <div class="container-msdesc col-xs-12 col-sm-12 col-md-6 col-lg-6 split split-horizontal" id="ms-desc">
                {view:view-msDesc-html($rec)}                
        </div>        
};

declare function view:view-msDesc-html($rec as node()){
    if($rec/tei:teiHeader/@xml:lang = 'sv') then 
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/tei2html_sv.xsl")),() )
    else
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/tei2html_en.xsl")),() )
};

declare function view:get-person($node as node(), $model as map(*)) as node(){    
    let $displayURI := request:get-parameter('person', '')
    let $rec := doc(concat($config:data-root, "/id/person/", $displayURI))/tei:TEI    
    return
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
                {view:view-person-html($rec)}            
        </div>
};

declare function view:view-person-html($rec as node()){
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/persons.xsl")),() )
};

declare function view:get-place($node as node(), $model as map(*)) as node(){    
    let $displayURI := request:get-parameter('place', '')
    let $rec := doc(concat($config:data-root, "/id/place/", $displayURI))/tei:TEI    
    return
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
                {view:view-place-html($rec)}            
        </div>
};

declare function view:view-place-html($rec as node()){
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/places.xsl")),() )
};

declare function view:get-bibl($node as node(), $model as map(*)) as node(){    
    let $displayURI := request:get-parameter('bibl', '')
    let $rec := doc(concat($config:data-root, "/id/bibl/", $displayURI))/tei:TEI    
    return
         <div class="col-md-6 col-lg-6 split split-horizontal" id="bibl">
                {view:view-bibl-html($rec)}                             
        </div>
        
        
};

declare function view:view-bibl-html($rec as node()){
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/bibl.xsl")),() )
};

declare function view:get-org($node as node(), $model as map(*)) as node(){    
    let $displayURI := request:get-parameter('org', '')
    let $rec := doc(concat($config:data-root, "/id/org/", $displayURI))/tei:TEI    
    return
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
                {view:view-org-html($rec)}            
        </div>
};

declare function view:view-org-html($rec as node()){
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/organizations.xsl")),() )
};

(:List manuscripts where bibl occurs - Work in progress:)
declare function view:get-bibl-mss-ref($rec as node()){
    for $mss in collection($config:data-root || "/msDescs")
    for $bibl in $mss//tei:bibl/tei:title/@ref
    let $title := $mss//tei:titleStmt/tei:title
    let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
    return 
     <tr>
         <td><a href="/{substring-before($uri, '.xml')}">{$title}</a></td>
     </tr>
};