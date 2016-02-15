xquery version "3.0";

module namespace browse="http://www.manuscripta.se/xquery/browse";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
import module namespace kwic="http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare %templates:wrap 
(: The %templates:wrap annotation copies the wrapper element :)
function browse:authors($node as node(), $model as map(*)) { 
        <table class="table table-striped">
        <tr>
            <th>Author</th>
            <th>Work</th>
            <th>Shelfmark</th>
            <th>Locus</th>
        </tr>{
            for $mss in collection($config:data-root || "/msDescs")
            for $codicological_unit in $mss//tei:msPart
            for $msitem in $codicological_unit//tei:msContents/tei:msItem[not(@class="blank_page") and not(@class="note")] 
            let $author := $msitem/tei:author//tei:persName
            let $title := $msitem/tei:title[not(@type="alt")][1]
            for $locus in $msitem/tei:locus
            let $idno := $mss//tei:msDesc/tei:msIdentifier/tei:idno
            let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
           order by 
                if($browse:sort = 'work') then $title
                else if($browse:sort = 'shelfmark') then $idno
                else $author    
            return
                <tr>
                    <td>{$author}</td>
                    <td><em>{$title//text()}</em></td>
                    <td>{$idno/text()}</td>
                    <td><a href="/{substring-before($uri, '.xml')}">f. {data($locus/@from)}–{data($locus/@to)}</a></td>
                </tr>
        }
        </table>
};

declare %templates:wrap 
(: The %templates:wrap annotation copies the wrapper element :)
function browse:incipits($node as node(), $model as map(*)) { 
        <table class="table table-striped">
        <tr>
            <th width='40%'>Incipit</th>
            <th width='20%'>Author</th>
            <th width='20%'>Work</th>            
            <th>Shelfmark</th>
            <th>Locus</th>
        </tr>{
            for $mss in collection($config:data-root || "/msDescs") 
                for $msitem in $mss//tei:msContents/tei:msItem 
                    for $incipit in $msitem/tei:incipit[@defective='true' or @defective='false']
                        let $locus := $msitem/tei:locus
                        let $idno := $mss//tei:msDesc/tei:msIdentifier/tei:idno
                        let $author := $msitem/tei:author
                        let $title := $msitem/tei:title
                        let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
            order by $incipit ascending collation "?lang=el" 
            return
                <tr>
                    <td>{$incipit//text()}</td>
                    <td>{$author//text()}</td>
                    <td><em>{$title//text()}</em></td>
                    <td>{$idno/text()}</td>
                    <td><a href="/{substring-before($uri, '.xml')}">f. {data($locus/@from)}</a></td>                    
                </tr>
        }
        </table>
};

declare function browse:manuscripts-old($node as node(), $model as map(*)) { 
    <table class="table table-striped">
        <tr>
            <th>Shelfmark</th>
            <th>Date</th>
            <th>Support</th>
            <th>Contents</th>
        </tr>{
        for $mss in collection("/db/apps/manuscripta.se/data/msDescs")
        for $material in $mss//tei:supportDesc
        for $date in $mss//tei:origin//tei:origDate
        for $idno in $mss//tei:msIdentifier/tei:idno
        for $contents in $mss//tei:msContents/tei:summary
        order by $mss//tei:msDesc/@xml:id
        return
            <tr>
                <td><a href="data/msDescs/{replace(base-uri($mss), '.+/(.+)$', '$1')}">{$idno/text()}</a></td>
                <td>{$date/text()}</td>
                <td>{data($material/@material)}</td>
                <td>{$contents/text()}</td>
            </tr>
        }
        </table>
};

declare %templates:wrap 
(: The %templates:wrap annotation copies the wrapper element :)
function browse:scribes($node as node(), $model as map(*)) { 
        <table class="table table-striped">
        <tr>
            <th>Scribe</th>            
            <th>Shelfmark</th>            
        </tr>{
            for $mss in collection($config:data-root || "/msDescs") 
            for $scribe in $mss//tei:handNote//tei:persName[@role="scribe"]            
            for $idno in $mss//tei:msDesc/tei:msIdentifier/tei:idno
            let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
            order by $scribe ascending
            return
                <tr>
                    <td>{$scribe//text()}</td>                                        
                    <td><a href="/{substring-before($uri, '.xml')}">{$idno}</a></td>
                </tr>
        }
        </table>
};

(: global variable to pass in sort from url:)
declare variable $browse:sort {request:get-parameter('sort', '')};

declare %templates:wrap
(: The %templates:wrap annotation copies the wrapper element :)
function browse:list-manuscripts($node as node(), $model as map(*)){
    for $mss in collection($config:data-root || "/msDescs")
    let $title := $mss//tei:titleStmt/tei:title
    let $date := $mss//tei:msDesc/tei:history/tei:origin//tei:origDate
    let $support := distinct-values($mss//tei:supportDesc[1]/@material)
    let $summary := $mss//tei:msDesc/tei:head
    let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')    
    order by 
        if($browse:sort = 'summary') then $summary
        else if($browse:sort = 'date') then $date/@to  
        else if($browse:sort = 'support') then $support
        else $mss//tei:TEI/@xml:id
    return 
        browse:display-manuscripts($title,$uri,$date,$support,$summary)
};

declare function browse:display-manuscripts($title as xs:string?, $uri as xs:anyURI?, $date as xs:string?, $support as xs:string*, $summary as xs:string*) as node()*{
                <tr>
                    <td><a href="/{substring-before($uri, '.xml')}">{$title}</a></td>
                    <td>{$date}</td>
                    <td>{$support}</td>
                    <td>{$summary}</td>
                  </tr> 
       };