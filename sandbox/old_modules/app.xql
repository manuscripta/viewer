xquery version "3.0";

module namespace app="http://www.manuscripta.se/xquery/app";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
import module namespace kwic="http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function app:list_authors($node as node(), $model as map(*)) { 
        <table class="table table-striped">
        <tr>
            <th>Author</th>
            <th>Work</th>
            <th>Shelfmark</th>
            <th>Locus</th>
        </tr>{
            for $mss in collection("/db/apps/manuscripta.se/data/msDescs") 
            for $codicological_unit in $mss//tei:msPart
            for $msitem in $codicological_unit//tei:msContents/tei:msItem[not(@class="blank_page") and not(@class="note")] 
            let $author := $msitem/tei:author//tei:persName
            let $title := $msitem/tei:title[not(@type="alt")][1]
            for $locus in $msitem/tei:locus
            let $idno := $mss//tei:msDesc/tei:msIdentifier/tei:idno
            let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
           order by 
                if($app:sort = 'work') then $title
                else if($app:sort = 'shelfmark') then $idno
                else $author    
            return
                <tr>
                    <td>{$author}</td>
                    <td><em>{$title//text()}</em></td>
                    <td>{$idno/text()}</td>
                    <td><a href="{substring-before($uri, '.xml')}">f. {data($locus/@from)}–{data($locus/@to)}</a></td>
                </tr>
        }
        </table>
};

declare function app:list_incipit($node as node(), $model as map(*)) { 
        <table class="table table-striped">
        <tr>
            <th width='40%'>Incipit</th>
            <th width='20%'>Author</th>
            <th width='20%'>Work</th>            
            <th>Shelfmark</th>
            <th>Locus</th>
        </tr>{
            for $mss in collection("/db/apps/manuscripta.se/data/msDescs") 
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
                    <td><a href="{substring-before($uri, '.xml')}">f. {data($locus/@from)}</a></td>                    
                </tr>
        }
        </table>
};

declare function app:list_mss($node as node(), $model as map(*)) { 
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

declare function app:list_scribes($node as node(), $model as map(*)) { 
        <table class="table table-striped">
        <tr>
            <th>Scribe</th>            
            <th>Shelfmark</th>            
        </tr>{
            for $mss in collection("/db/apps/manuscripta.se/data/msDescs") 
            for $scribe in $mss//tei:handNote//tei:persName[@role="scribe"]            
            for $idno in $mss//tei:msDesc/tei:msIdentifier/tei:idno
            let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
            order by $scribe ascending
            return
                <tr>
                    <td>{$scribe//text()}</td>                                        
                    <td><a href="{substring-before($uri, '.xml')}">{$idno}</a></td>
                </tr>
        }
        </table>
};


(:declare function app:list_works($node as node(), $model as map(*)) { 
        <ul class="list-unstyled">{
            for $mss in collection("/db/apps/manuscripta/data/msDescs"), 
                $msitem in $mss//tei:msContents/tei:msItem, 
                $title in $msitem/tei:title[@type="uniform"],
                $locus in $msitem/tei:locus,
                $idno in $mss//tei:msIdentifier/tei:idno
            order by $title ascending 
            return
                <li>{$title//text()} (<a href="data/msDescs/{replace(base-uri($mss), '.+/(.+)$', '$1')}">{$idno/text()}: f. {data($locus/@from)}</a>)</li>
        }
        </ul>
};:)


declare function app:search($node as node(), $model as map(*)) {
    <table class="table table-striped">
        <tr>
            <th>Author</th>
            <th>Work</th>            
            <th>Shelfmark</th>
            <th>Locus</th>
        </tr>{
        for $mss in collection("/db/apps/manuscripta.se/data/msDescs")
        for $msitem in $mss//tei:msContents/tei:msItem
        for $author in $msitem/tei:author
        for $title in $msitem/tei:title
        for $locus in $msitem/tei:locus
        for $idno in $mss//tei:msDesc/tei:msIdentifier/tei:idno
        let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
        let $au := request:get-parameter('au', ())
        let $ti := request:get-parameter('ti', ())
        let $pl := request:get-parameter('pl', ())
        return
            if (exists($au) and $au !='') then
                for $aut in $msitem/tei:author[ft:query(., $au)] 
                order by $author ascending 
                return
                    <tr>
                        <td>{$author}</td>
                        <td><em>{$title//text()}</em></td>
                        <td>{$idno/text()}</td>
                        <!--<td><a href="data/msDescs/{replace(base-uri($mss), '.+/(.+)$', '$1')}">f. {data($locus/@from)}–{data($locus/@to)}</a></td>-->
                        <td><a href="{substring-before($uri, '.xml')}">f. {data($locus/@from)}–{data($locus/@to)}</a></td>
                    </tr>               
            else if (exists($ti) and $ti !='') then          
                for $title in $msitem/tei:title[ft:query(., $ti)] 
                order by $title ascending 
                return
                    <tr>
                        <td>{$author}</td>
                        <td><em>{$title//text()}</em></td>
                        <td>{$idno/text()}</td>
                        <!--<td><a href="data/msDescs/{replace(base-uri($mss), '.+/(.+)$', '$1')}">f. {data($locus/@from)}–{data($locus/@to)}</a></td>-->
                        <td><a href="view.html?uri={encode-for-uri($uri)}&amp;view=html">f. {data($locus/@from)}–{data($locus/@to)}</a></td>
                    </tr>
             else if (exists($pl) and $pl !='') then          
                for $place in $mss//tei:placeName[ft:query(., $pl)] 
                order by $title ascending 
                return
                    <tr>
                        <td>{$author}</td>
                        <td><em>{$title//text()}</em></td>
                        <td>{$idno/text()}</td>
                        <!--<td><a href="data/msDescs/{replace(base-uri($mss), '.+/(.+)$', '$1')}">f. {data($locus/@from)}–{data($locus/@to)}</a></td>-->
                        <td><a href="view.html?uri={encode-for-uri($uri)}&amp;view=html">f. {data($locus/@from)}–{data($locus/@to)}</a></td>
                    </tr>
            else
                ()
        }
    </table>
};

declare function app:search2($node as node(), $model as map(*)) {
    <table class="table table-striped">
        <tr>
            <th>Shelfmark</th>            
            <th>Hit</th>
        </tr>{
        for $mss in collection("/db/apps/manuscripta.se/data/msDescs")
        let $msitem := $mss//tei:msContents/tei:msItem
        let $title := $mss//tei:titleStmt/tei:title        
        let $summary := $mss//tei:msDesc/tei:head
        let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
        let $query := request:get-parameter('query', '')
        let $mode := request:get-parameter('mode', '')        
        return
            if ($mode eq 'au') then
                for $hit in $msitem/tei:author[ft:query(., $query)]
                let $shelfmark := $hit/ancestor::*//tei:titleStmt/tei:title/text()
                let $author := $hit/parent::tei:msItem/tei:author
                let $work := $hit/parent::tei:msItem/tei:title
                let $locus := data($hit/parent::tei:msItem/tei:locus/@from)
                order by $title ascending 
                return
                    <tr>
                        <td><a href="{substring-before($uri, '.xml')}">{$shelfmark}, f. {$locus}</a></td>
                        <td>{kwic:summarize($author, <config xmlns="" width="100"/>)}, <em>{data($work)}</em></td>                        
                    </tr>
                    
            else if ($mode eq 'ti') then
                for $hit in $msitem/tei:title[ft:query(., $query)]                
                order by $title ascending 
                return
                    <tr>
                        <td><a href="{substring-before($uri, '.xml')}">{data($title)}</a></td>
                        <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</td>
                    </tr>
                    
             else if ($mode eq 'pl') then
                for $place in $mss//tei:placeName[ft:query(., $query)] 
                order by $place ascending 
                return
                    <tr>
                        <td><a href="{substring-before($uri, '.xml')}">{data($title)}</a></td>
                        <td>{data($place)}</td>                        
                    </tr>
                    
             else if ($mode eq 'in') then
                for $hit in $mss//tei:incipit[ft:query(., $query)]                             
                order by $title ascending 
                return
                    <tr>                        
                        <td><a href="{substring-before($uri, '.xml')}">{data($title)}</a></td>
                        <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</td>
                    </tr>
                    
             else if ($mode eq 'ex') then
                for $hit in $msitem/tei:explicit[ft:query(., $query)] 
                order by $title ascending 
                return
                    <tr>                        
                        <td><a href="{substring-before($uri, '.xml')}">{data($title)}</a></td>
                        <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</td>
                    </tr>
                    
            else if ($mode eq 'ru') then
                for $hit in $msitem/tei:rubric[ft:query(., $query)] 
                order by $title ascending
                return
                    <tr>                        
                        <td><a href="{substring-before($uri, '.xml')}">{data($title)}</a></td>
                        <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</td>
                    </tr>
                    
            else
                ()
        }
    </table>
};




declare function app:search_simple($node as node(), $model as map(*)) {
<table class="table table-striped">
        {
               let $search-expression := request:get-parameter('query', '')
               for $mss in collection("/db/apps/manuscripta.se/data/msDescs")
               for $idno in $mss//tei:msIdentifier/tei:idno
        	 for $hit in $mss//*[ft:query(., $search-expression)]        	 
        	 let $expanded := kwic:expand($hit)
        	 order by ft:score($hit) descending
        	 return kwic:get-summary($expanded, ($expanded//exist:match)[1], <config width="40" />)
         }
         </table>
};







(: global variable to pass in sort from url:)
declare variable $app:sort {request:get-parameter('sort', '')};

(:~
 : Browse using sort
 : Using user defined functions to modularize code
 : Alternative to collection would be to use : xmldb:get-child-resources($config:app-root || "/data/indexed-plays")
 : @node used by eXist templates
 : @model used by eXist templates
:)
declare %templates:wrap function app:browse-list-items($node as node(), $model as map(*)){
    for $mss in collection($config:data-root || "/msDescs")
    let $title := $mss//tei:titleStmt/tei:title
    let $date := $mss//tei:msDesc/tei:history/tei:origin//tei:origDate
    let $support := distinct-values($mss//tei:supportDesc[1]/@material)
    let $summary := $mss//tei:msDesc/tei:head
    let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')    
    order by 
        if($app:sort = 'summary') then $summary
        else if($app:sort = 'date') then $date/@to  
        else if($app:sort = 'support') then $support
        else $mss//tei:TEI/@xml:id        
        (: Dynamic sort and sort order, does not work, may be eXist bug. Could use util:eval 
            on whole FLWOR expression
            if ($app:sort = 'death') then $content else () descending,
            if ($app:sort = 'title') then $sort-title else () ascending,
            if ($app:sort = 'date') then $date else () ascending,
            if (not(exists($app:sort))) then $sort-title else () ascending
        :)
    return 
        app:display-title($title,$uri,$date,$support,$summary)
}; 

(:~
 : Build title element with links to html, pdf, and xml views of the data.
 : Using user defined functions to modularize code
 : Alternative to collection would be to use : xmldb:get-child-resources($config:app-root || "/data/indexed-plays")
 : @title play title
 : @uri play uri
 : @date play date
 : @death number of deaths in play
:)
declare function app:display-title($title as xs:string?, $uri as xs:anyURI?, $date as xs:string?, $support as xs:string*, $summary as xs:string*) as node()*{
                <tr>
                    <td><a href="{substring-before($uri, '.xml')}">{$title}</a></td>
                    <td>{$date}</td>
                    <td>{$support}</td>
                    <td>{$summary}</td>
                  </tr> 
       };

