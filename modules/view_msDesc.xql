xquery version "3.0";

module namespace view = "http://www.manuscripta.se/xquery/view";

import module namespace templates = "http://exist-db.org/xquery/templates";
import module namespace config = "http://www.manuscripta.se/xquery/config" at "config.xqm";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xmldb = "http://exist-db.org/xquery/xmldb";

declare function view:get-msDesc($node as node(), $model as map(*)) as node() {
    let $displayURI := request:get-parameter('id', '')
    let $rec := doc(concat($config:data-root, "/msDescs/", $displayURI))/tei:TEI
    return
        <div
            class="container-msdesc col-xs-12 col-sm-12 col-md-6 col-lg-6 split split-horizontal"
            id="ms-desc">
            {view:view-msDesc-html($rec)}
        </div>
};

declare function view:view-msDesc-html($rec as node()) {
    if ($rec/tei:teiHeader/@xml:lang = 'sv') then
        transform:transform($rec, doc(concat($config:app-root, "/stylesheets/tei2html_sv.xsl")), ())
    else
        transform:transform($rec, doc(concat($config:app-root, "/stylesheets/tei2html_en.xsl")), ())
};

declare function view:get-person($node as node(), $model as map(*)) as node() {
    let $displayURI := request:get-parameter('person', '')
    let $rec := doc(concat($config:data-root, "/id/person/", $displayURI))/tei:TEI
    return
        <div class="col-md-12 col-lg-10">
            {view:view-person-html($rec)}
            <h3>Associated Manuscripts</h3>
            <table class='table table-striped'>
                <thead>
                    <tr>
                        <th width='20%'>Repository</th>
                        <th width='10%'>Shelfmark</th>
                        <th width='70%'>Heading</th>
                    </tr>
                </thead>
                <tbody>
                    {view:get-person-mss-ref($rec)}
                </tbody>
            </table>
        </div>
};

declare function view:view-person-html($rec as node()) {
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/persons.xsl")), ())
};

declare function view:get-place($node as node(), $model as map(*)) as node() {
    let $displayURI := request:get-parameter('place', '')
    let $rec := doc(concat($config:data-root, "/id/place/", $displayURI))/tei:TEI
    return
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
            {view:view-place-html($rec)}
            <h3>Associated Manuscripts</h3>
            <table class='table table-striped'>
                <thead>
                    <tr>
                        <th width='30%'>Repository</th>
                        <th width='20%'>Shelfmark</th>
                        <th width='50%'>Heading</th>
                    </tr>
                </thead>
                <tbody>
                    {view:get-place-mss-ref($rec)}
                </tbody>
            </table>            
        </div>
};

declare function view:view-place-html($rec as node()) {
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/places.xsl")), ())
};

declare function view:get-bibl($node as node(), $model as map(*)) as node() {
    let $displayURI := request:get-parameter('bibl', '')
    let $rec := doc(concat($config:data-root, "/id/bibl/", $displayURI))/tei:TEI
    return
        <div class="col-md-6 col-lg-6 split split-horizontal" id="bibl">
            {view:view-bibl-html($rec)}
            <h3>Associated Manuscripts</h3>
            <table class='table table-striped'>
                <thead>
                    <tr>
                        <th width='30%'>Repository</th>
                        <th width='20%'>Shelfmark</th>
                        <th width='50%'>Heading</th>
                    </tr>
                </thead>
                <tbody>
                    {view:get-bibl-mss-ref($rec)}
                </tbody>
            </table>
        </div>
};

declare function view:view-bibl-html($rec as node()) {
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/bibl.xsl")), ())
};

declare function view:get-org($node as node(), $model as map(*)) as node() {
    let $displayURI := request:get-parameter('org', '')
    let $rec := doc(concat($config:data-root, "/id/org/", $displayURI))/tei:TEI
    return
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
            {view:view-org-html($rec)}        
        <h3>Associated Manuscripts</h3>
            <table class='table table-striped'>
                <thead>
                    <tr>
                        <th width='30%'>Repository</th>
                        <th width='20%'>Shelfmark</th>
                        <th width='50%'>Heading</th>
                    </tr>
                </thead>
                <tbody>
                    {view:get-org-mss-ref($rec)}
                </tbody>
            </table>
        </div>
};

declare function view:view-org-html($rec as node()) {
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/organizations.xsl")), ())
};

declare function view:get-work($node as node(), $model as map(*)) as node() {
    let $displayURI := request:get-parameter('work', '')
    let $rec := doc(concat($config:data-root, "/id/work/", $displayURI))/tei:TEI
    return
        <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
            {view:view-work-html($rec)}
            <h3>Associated Manuscripts</h3>
            <table class='table table-striped'>
                <thead>
                    <tr>
                        <th width='30%'>Repository</th>
                        <th width='20%'>Shelfmark</th>
                        <th width='50%'>Heading</th>
                    </tr>
                </thead>
                <tbody>
                    {view:get-work-mss-ref($rec)}
                </tbody>
            </table>
        </div>
};

declare function view:view-work-html($rec as node()) {
    transform:transform($rec, doc(concat($config:app-root, "/stylesheets/works.xsl")), ())
};

(:List manuscripts where bibl occurs:)
declare function view:get-bibl-mss-ref($rec as node()) {
    let $ref := $rec//tei:publicationStmt/tei:idno[@subtype = 'Manuscripta']    
    for $mss in collection($config:data-root || "/msDescs")    
    let $repository := $mss//tei:repository
    let $shelfmark := $mss//tei:msIdentifier/tei:idno[@type = 'shelfmark']
    let $ManuscriptaID := $mss//tei:TEI/substring-after(@xml:id, 'ms-')
    let $head := $mss//tei:msDesc/tei:head
    where $mss//*[tei:bibl/tei:title/@ref = $ref]
    order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
    return        
        <tr>
            <td>{$repository}</td>
            <td><a href="../ms/{$ManuscriptaID}">{$shelfmark}</a></td>
            <td>{$head}</td>
        </tr>        
};

(:List manuscripts where person occurs:)
declare function view:get-person-mss-ref($rec as node()) {
    let $ref := $rec//tei:publicationStmt/tei:idno[@subtype = 'Manuscripta']    
    for $mss in collection($config:data-root || "/msDescs")    
    let $repository := $mss//tei:repository
    let $shelfmark := $mss//tei:msIdentifier/tei:idno[@type = 'shelfmark']
    let $ManuscriptaID := $mss//tei:TEI/substring-after(@xml:id, 'ms-')
    let $head := $mss//tei:msDesc/tei:head    
    where $mss//*[tei:persName/@ref = $ref]    
    order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
    return        
        <tr>
            <td>{$repository}</td>
            <td><a href="../ms/{$ManuscriptaID}">{$shelfmark}</a></td>
            <td>{$head}</td>
        </tr>        
};

(:List manuscripts where place occurs:)
declare function view:get-place-mss-ref($rec as node()) {
    let $ref := $rec//tei:publicationStmt/tei:idno[@subtype = 'Manuscripta']    
    for $mss in collection($config:data-root || "/msDescs")    
    let $repository := $mss//tei:repository
    let $shelfmark := $mss//tei:msIdentifier/tei:idno[@type = 'shelfmark']
    let $ManuscriptaID := $mss//tei:TEI/substring-after(@xml:id, 'ms-')
    let $head := $mss//tei:msDesc/tei:head    
    where $mss//*[tei:placeName/@ref = $ref]    
    order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
    return        
        <tr>
            <td>{$repository}</td>
            <td><a href="../ms/{$ManuscriptaID}">{$shelfmark}</a></td>
            <td>{$head}</td>
        </tr>        
};

(:List manuscripts where work occurs:)
declare function view:get-work-mss-ref($rec as node()) {
    let $ref := $rec//tei:publicationStmt/tei:idno[@subtype = 'Manuscripta']    
    for $mss in collection($config:data-root || "/msDescs")    
    let $repository := $mss//tei:repository
    let $shelfmark := $mss//tei:msIdentifier/tei:idno[@type = 'shelfmark']
    let $ManuscriptaID := $mss//tei:TEI/substring-after(@xml:id, 'ms-')
    let $head := $mss//tei:msDesc/tei:head    
    where $mss//*[tei:msItem/tei:title/@ref = $ref]    
    order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
    return        
        <tr>
            <td>{$repository}</td>
            <td><a href="../ms/{$ManuscriptaID}">{$shelfmark}</a></td>
            <td>{$head}</td>
        </tr>        
};

(:List manuscripts where organization occurs:)
declare function view:get-org-mss-ref($rec as node()) {
    let $ref := $rec//tei:publicationStmt/tei:idno[@subtype = 'Manuscripta']    
    for $mss in collection($config:data-root || "/msDescs")    
    let $repository := $mss//tei:repository
    let $shelfmark := $mss//tei:msIdentifier/tei:idno[@type = 'shelfmark']
    let $ManuscriptaID := $mss//tei:TEI/substring-after(@xml:id, 'ms-')
    let $head := $mss//tei:msDesc/tei:head    
    where $mss//*[tei:orgName/@ref = $ref]    
    order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
    return        
        <tr>
            <td>{$repository}</td>
            <td><a href="../ms/{$ManuscriptaID}">{$shelfmark}</a></td>
            <td>{$head}</td>
        </tr>        
};

