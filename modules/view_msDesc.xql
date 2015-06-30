xquery version "3.0";

module namespace view="http://www.manuscripta.se/xquery/view";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

declare function view:view-msDesc-html($rec as node()){
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/tei2html.xsl")),() )
};

declare function view:get-msDesc($node as node(), $model as map(*)) as node(){    
    let $displayURI := request:get-parameter('id', '')
    let $rec := doc(concat($config:data-root, "/msDescs/", $displayURI))/tei:TEI    
    return
        <div class="container-msdesc col-xs-12 col-sm-12 col-md-6 col-lg-6">
                {view:view-msDesc-html($rec)}            
        </div>
};

declare function view:view-bibliography-html($rec as node()){
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/bibl2html.xsl")),() )
};

declare function view:get-bibliography($node as node(), $model as map(*)) as node(){    
    let $rec := doc(concat($config:data-root, "/authority_files/bibliography.xml"))    
    return
        <div class="col-xs-12 col-sm-12 col-md-10 col-lg-10">
                {view:view-bibliography-html($rec)}                
        </div>
};

declare function view:view-bibliography-item-html($item as node()){
    transform:transform($item, doc(concat($config:app-root,"/stylesheets/biblitem2html.xsl")),() )
};

declare function view:get-bibliography-item($node as node(), $model as map(*)) as node(){
    let $bibID := request:get-parameter('item', '')
    let $item := doc(concat($config:data-root, "/authority_files/bibliography.xml"))//tei:bibl[@xml:id=$bibID]
    (:for $mss in collection($config:data-root || "/msDescs")//tei:additional//tei:bibl/tei:ref[@target=concat("http://beta.manuscripta.se/bibliography/" , $bibID)]
    let $idno := $mss//tei:msDesc/tei:msIdentifier/tei:idno    :)
    return
        <div class="col-xs-12 col-sm-12 col-md-10 col-lg-10">
                {view:view-bibliography-item-html($item)}                
        </div>
};

declare function view:test($node as node(), $model as map(*)) as node(){
    let $bibID := request:get-parameter('item', '')
return
    <div class="col-xs-12 col-sm-12 col-md-10 col-lg-10">
               <p>ID is {$bibID}</p>            
        </div>
};