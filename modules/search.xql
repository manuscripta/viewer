xquery version "3.0";

module namespace search="http://www.manuscripta.se/xquery/search";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
import module namespace kwic="http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function search:search($node as node(), $model as map(*)) {
    <table class="table table-striped">
        <tr>
            <th>Author</th>
            <th>Work</th>            
            <th>Shelfmark</th>
            <th>Locus</th>
        </tr>{
        for $mss in collection($config:data-root || "/msDescs")
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

declare function search:beta_search($node as node(), $model as map(*)) {
    <table class="table table-striped">
        {
        for $mss in collection($config:data-root || "/msDescs")
        let $msitem := $mss//tei:msContents/tei:msItem
        let $title := $mss//tei:titleStmt/tei:title        
        let $summary := $mss//tei:msDesc/tei:head
        let $uri := replace(base-uri($mss), '.+/(.+)$', '$1')
        let $query := request:get-parameter('q', '')
        let $mode := request:get-parameter('m', '')        
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
                for $hit in $msitem/tei:incipit[ft:query(., $query)]                             
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




declare function search:search_simple($node as node(), $model as map(*)) {
<table class="table table-striped">
        {
               let $search-expression := request:get-parameter('query', '')
               for $mss in collection($config:data-root || "/msDescs")
               for $idno in $mss//tei:msIdentifier/tei:idno
        	 for $hit in $mss//*[ft:query(., $search-expression)]        	 
        	 let $expanded := kwic:expand($hit)
        	 order by ft:score($hit) descending
        	 return kwic:get-summary($expanded, ($expanded//exist:match)[1], <config width="40" />)
         }
         </table>
};
