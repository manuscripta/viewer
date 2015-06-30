xquery version "3.0";

module namespace play="http://xqueryinstitute.org/play";

(:
 : Retrieve play xml transform with xsl for html output
:)

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

(:~
 : Runs play through xslt transformation
 : @param $uri passes internal uri for play
:)
declare function play:view-play-html($rec as node()){
    transform:transform($rec, doc('../data/stylesheets/tei2html.xsl'),() )
};

(:~
 : Retrieve play xml transform with xsl for html output
 : @param $uri passes internal uri for play
:)
declare function play:get-play($node as node(), $model as map(*)) as node(){
    let $displayURI := request:get-parameter('uri', '')
    (:let $displayURI := $uri:)
    (:let $displayURI := replace($uri,'/indexed-plays','/plays'):)
    let $rec := doc(concat("/db/apps/manuscripta.se/data/msDescs/", $displayURI))/tei:TEI
    (:let $jsURI := doc(concat("/db/apps/manuscripta.se/data/msDescs/", $displayURI))/tei:TEI/@xml:id:)
    return 
        (:<div>
            <div class="col-md-12">
                {play:view-play-html($rec)}
            </div>
        </div>:)
        <div class="container-msdesc col-xs-12 col-sm-12 col-md-6 col-lg-6">
                {play:view-play-html($rec)}            
        </div>
};

