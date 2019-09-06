xquery version "3.0";

module namespace browse="http://www.manuscripta.se/xquery/browse";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
import module namespace kwic="http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";
import module namespace functx="http://www.functx.com";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare %templates:wrap 
(: The %templates:wrap annotation copies the wrapper element :)
function browse:authors($node as node(), $model as map(*)) {
            for $mss in collection($config:data-root || "/msDescs")
            let $repository := $mss//tei:msDesc/tei:msIdentifier/tei:repository
            let $shelfmark := $mss//tei:msDesc/tei:msIdentifier/tei:idno[@type='shelfmark']
            for $codicological_unit in $mss//tei:msPart
            for $msitem in $codicological_unit//tei:msContents/tei:msItem 
            let $author := $msitem/tei:author//tei:persName
            let $title := $msitem/tei:title[not(@type="alt")][1]
            for $locus in $msitem/tei:locus            
            let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
            let $item-nr := $msitem/@n
           (:order by 
                if($browse:sort = 'work') then $title
                else if($browse:sort = 'shelfmark') then $idno
                else $author  :)  
            return                
                <tr>
                    <td>{$author}</td>
                    <td><em>{$title//text()}</em></td>
                    <td>{$repository}</td>
                    <td>{$shelfmark}</td>
                    <td><a href="/ms/{substring-before($uri, '.xml')}#item-{$item-nr}">f. {data($locus/@from)}–{data($locus/@to)}</a></td>
                </tr>                
};

declare %templates:wrap 
(: The %templates:wrap annotation copies the wrapper element :)
function browse:incipits($node as node(), $model as map(*)) { 
                for $mss in collection($config:data-root || "/msDescs")
                let $shelfmark := $mss//tei:titleStmt/tei:title
                for $msitem in $mss//tei:msContents/tei:msItem 
                    for $incipit in $msitem/tei:incipit[@defective='true' or @defective='false']
                        let $locus := $msitem/tei:locus                        
                        let $author := $msitem/tei:author
                        let $title := $msitem/tei:title
                        let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
            (:order by $incipit ascending collation "?lang=el":) 
            order by $incipit ascending collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
            return
                <tr>
                    <td>{$incipit//text()}</td>
                    <td>{$author//text()}</td>
                    <td><em>{$title//text()}</em></td>
                    <td>{$shelfmark/text()}, <a href="/ms/{substring-before($uri, '.xml')}">f. {data($locus/@from)}</a></td>
                </tr>
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
            for $idno in $mss//tei:msDesc/tei:msIdentifier/tei:idno[@type='shelfmark']
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
        let $repository := $mss//tei:msDesc/tei:msIdentifier/tei:repository/text()
        let $shelfmark := $mss//tei:msDesc/tei:msIdentifier/tei:idno[@type='shelfmark']/text()
        let $codicological_unit := $mss//tei:msPart
        let $unit_nr := $codicological_unit/tei:msIdentifier/tei:idno
        let $date := fn:string-join(if (exists($codicological_unit//tei:history/tei:origin//tei:origDate)) then $codicological_unit//tei:history/tei:origin//tei:origDate else $mss//tei:msDesc/tei:history/tei:origin//tei:origDate, ', ')        
        let $support := fn:string-join(distinct-values($codicological_unit//tei:supportDesc/@material), ', ')
        let $summary := $mss//tei:msDesc/tei:head/text()
        let $textLang := distinct-values($mss//tei:msContents/tei:textLang/@mainLang)
        let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
        let $digitized := boolean($mss//tei:facsimile)
        let $sponsor := $mss//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:sponsor
        order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
        return 
            <tr>
                    <td class="repository filter-select">{if ($repository='Kungliga biblioteket') then 'National Library' else if ($repository='Uppsala universitetsbibliotek') then 'Uppsala University Library' else $repository}</td>
                    <td><a href="/ms/{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                    <td>{$date}</td>
                    <td class="filter-select">{$support}</td>
                    <td  class="filter-select">{if ($textLang='sv') then 'Swedish' else if ($textLang='grc') then 'Greek' else if ($textLang='la') then 'Latin' else if ($textLang='non-swe') then 'Old Swedish' else if ($textLang='el') then 'Modern Greek' else if ($textLang='non-dan') then 'Old Danish' else $textLang}</td>
                    <td>{$summary}</td>
                    <td  class="filter-select">{if ($digitized=true()) then 'Yes' else 'No'}</td>                  
                  </tr> 
    (:order by 
        if($browse:sort = 'summary') then $summary
        else if($browse:sort = 'date') then $date/@to  
        else if($browse:sort = 'support') then $support
        else $mss//tei:TEI/@xml:id
    return 
        browse:display-manuscripts($repository, $shelfmark, $uri, $date, $support, $summary):)
}; 

declare %templates:wrap
(: The %templates:wrap annotation copies the wrapper element :)
function browse:list-greek-manuscripts($node as node(), $model as map(*)){
    for $mss in collection($config:data-root || "/msDescs")        
        let $repository := $mss//tei:msDesc/tei:msIdentifier/tei:repository/text()
        let $shelfmark := $mss//tei:msDesc/tei:msIdentifier/tei:idno[@type='shelfmark']/text()
        let $codicological_unit := $mss//tei:msPart
        let $unit_nr := $codicological_unit/tei:msIdentifier/tei:idno
        let $date := fn:string-join(if (exists($codicological_unit//tei:history/tei:origin//tei:origDate)) then $codicological_unit//tei:history/tei:origin//tei:origDate else $mss//tei:msDesc/tei:history/tei:origin//tei:origDate, ', ')        
        let $support := fn:string-join(distinct-values($codicological_unit//tei:supportDesc/@material), ', ')
        let $summary := $mss//tei:msDesc/tei:head/text()
        let $textLang := distinct-values($mss//tei:msContents/tei:textLang/@mainLang)
        let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
        let $digitized := boolean($mss//tei:facsimile)
        let $sponsor := $mss//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:sponsor
        where $sponsor = 'Greek manuscripts in Sweden – a digitization and cataloguing project'
        order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
        return 
            <tr>
                    <td class="repository filter-select">{if ($repository='Kungliga biblioteket') then 'National Library' else if ($repository='Uppsala universitetsbibliotek') then 'Uppsala University Library' else $repository}</td>
                    <td><a href="/ms/{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                    <td>{$date}</td>
                    <td>{$support}</td>
                    <td>{if ($textLang='sv') then 'Swedish' else if ($textLang='grc') then 'Greek' else if ($textLang='el') then 'Modern Greek' else if ($textLang='la') then 'Latin' else if ($textLang='non-swe') then 'Old Swedish' else $textLang}</td>
                    <td>{$summary}</td>
                    <td>{if ($digitized=true()) then 'Yes' else 'No'}</td>                    
                  </tr>    
}; 

declare %templates:wrap
(: The %templates:wrap annotation copies the wrapper element :)
function browse:list-ttt-manuscripts($node as node(), $model as map(*)){
    for $mss in collection($config:data-root || "/msDescs")        
        let $repository := $mss//tei:msDesc/tei:msIdentifier/tei:repository/text()
        let $shelfmark := $mss//tei:msDesc/tei:msIdentifier/tei:idno[@type='shelfmark']/text()
        let $codicological_unit := $mss//tei:msPart
        let $unit_nr := $codicological_unit/tei:msIdentifier/tei:idno
        let $date := fn:string-join(if (exists($codicological_unit//tei:history/tei:origin//tei:origDate)) then $codicological_unit//tei:history/tei:origin//tei:origDate else $mss//tei:msDesc/tei:history/tei:origin//tei:origDate, ', ')        
        let $support := fn:string-join(distinct-values($codicological_unit//tei:supportDesc/@material), ', ')
        let $summary := $mss//tei:msDesc/tei:head/text()
        let $textLang := distinct-values($mss//tei:msContents/tei:textLang/@mainLang)
        let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
        let $digitized := boolean($mss//tei:facsimile)
        let $sponsor := $mss//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:sponsor
        where $sponsor = 'TTT: Text till tiden! Medeltida texter i kontext – då och nu'
        order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
        return 
            <tr>
                    <td class="repository filter-select">{if ($repository='Kungliga biblioteket') then 'National Library' else if ($repository='Uppsala universitetsbibliotek') then 'Uppsala University Library' else $repository}</td>
                    <td><a href="/ms/{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                    <td>{$date}</td>
                    <td>{$support}</td>
                    <td>{if ($textLang='sv') then 'Swedish' else if ($textLang='grc') then 'Greek' else if ($textLang='el') then 'Modern Greek' else if ($textLang='la') then 'Latin' else if ($textLang='non-swe') then 'Old Swedish' else $textLang}</td>
                    <td>{$summary}</td>
                    <td>{if ($digitized=true()) then 'Yes' else 'No'}</td>                    
                  </tr>    
}; 


declare function browse:display-manuscripts($repository as xs:string?, $shelfmark as xs:string?, $uri as xs:anyURI?, $date as xs:string?, $support as xs:string*, $summary as xs:string*) as node()*{
                <tr>
                    <td>{$repository}</td>
                    <td><a href="/{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                    <td>{$date}</td>
                    <td>{$support}</td>
                    <td>{$summary}</td>
                  </tr> 
       };