xquery version "3.1";

module namespace search="http://www.manuscripta.se/xquery/search";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
(:import module namespace kwic="http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";:)
import module namespace kwic="http://exist-db.org/xquery/kwic";

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

declare %templates:wrap
function search:beta_search($node as node(), $model as map(*)) {    
            <table class="tablesorter">
                <thead>
                    <tr>
                        <th width="60%">Hit</th>                        
                        <th class="filter-select" data-placeholder="All" width="20%">Repository</th>
                        <th width="10%">Shelfmark</th>                        
                    </tr>
                </thead>       
        {
        for $mss in collection($config:data-root || "/msDescs")        
            let $msitem := $mss//tei:msContents/tei:msItem        
            let $repository := $mss//tei:repository/text()
            let $shelfmark := $mss//tei:msIdentifier/tei:idno[@type = 'shelfmark']        
            let $uri := concat('/ms/', replace(base-uri($mss), '.+/(.+)$', '$1'))
            let $query := request:get-parameter('q', '')
            let $mode := request:get-parameter('m', '')
            order by $repository, $shelfmark collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
            return
                if ($mode eq 'author'  and ($query !='' and string-length($query) > 2)) then
                    for $hit in $msitem/tei:author[ft:query(., $query)]
                    let $results := kwic:summarize($hit, <config xmlns="" width="100"/>)
                    let $author := $hit/parent::tei:msItem/tei:author/normalize-space()                    
                    let $work := $hit/parent::tei:msItem/tei:title[@type='uniform']
                    let $locus := data($hit/parent::tei:msItem/tei:locus/@from)
                        order by $author ascending empty least
                        return
                            <tr>
                                <td>{$results}, <em>{data($work)}</em></td>
                                <td>{$repository}</td>
                                <td><a href="{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                            </tr>
                        
                            (:<div class="panel panel-default">
                                <div class="panel-heading">
                                    <h3 class="panel-title">{$repository}, {$shelfmark}</h3>
                                </div>
                                <div class="panel-body">
                                    <p><b>Locus: </b>f. {$locus}</p>
                                    <span><b>Author: </b>{kwic:summarize($author, <config xmlns="" width="100"/>)}</span>
                                    <p><b>Title: </b>{data($work)}</p>
                                </div>                        
                            </div>:)
                        
                else if ($mode eq 'title') then
                    for $hit in $msitem/tei:title[ft:query(., $query)]         
                        let $author := if (exists($hit/parent::tei:msItem/tei:author)) then concat($hit/parent::tei:msItem/tei:author/normalize-space(), ', ') else ()                        
                        order by $hit ascending collation "http://www.w3.org/2013/collation/UCA?numeric=yes"
                        return
                        <tr>
                            <td>{$author}<em>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</em></td>
                            <td>{$repository}</td>
                            <td><a href="{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                        </tr>
                 
                 else if ($mode eq 'person') then
                    for $hit in $mss//tei:persName[ft:query(., $query)]
                        let $context := $hit/name(parent::*)
                        order by $hit ascending
                        return
                            <tr>
                                <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}  ({$context})</td>
                                <td>{$repository}</td>
                                <td><a href="{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                            </tr>
                 
                 else if ($mode eq 'place') then
                    for $hit in $mss//tei:msDesc//tei:placeName[ft:query(., $query)]
                        let $context := $hit/name(parent::*)
                        order by $hit ascending 
                        return
                            <tr>
                                <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)} ({$context})</td>
                                <td>{$repository}</td>
                                <td><a href="{substring-before($uri, '.xml')}">{distinct-values($shelfmark)}</a></td>
                            </tr>
                        
                 else if ($mode eq 'incipit') then
                    for $hit in $msitem/tei:incipit[ft:query(., $query)]                             
                        order by $hit ascending 
                        return
                            <tr>
                                <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</td>
                                <td>{$repository}</td>
                                <td><a href="{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                            </tr>
                        
                 else if ($mode eq 'explicit') then
                    for $hit in $msitem/tei:explicit[ft:query(., $query)] 
                        order by $hit ascending 
                        return
                            <tr>
                                <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</td>
                                <td>{$repository}</td>
                                <td><a href="{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                            </tr>
                        
                else if ($mode eq 'rubric') then
                    for $hit in $msitem/tei:rubric[ft:query(., $query)] 
                        order by $hit ascending
                        return
                            <tr>
                                <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</td>
                                <td>{$repository}</td>
                                <td><a href="{substring-before($uri, '.xml')}">{$shelfmark}</a></td>
                            </tr>
                        
                else
                    ()
            }
    <tfoot>
                    <tr>
                        <th colspan="7" class="ts-pager form-inline">
                            <div class="btn-group btn-group-sm" role="group">
                                <button type="button" class="btn btn-default first">
                                    <span class="glyphicon glyphicon-step-backward"/>
                                </button>
                                <button type="button" class="btn btn-default prev">
                                    <span class="glyphicon glyphicon-backward"/>
                                </button>
                            </div>
                            <span class="pagedisplay"/>
                            <div class="btn-group btn-group-sm" role="group">
                                <button type="button" class="btn btn-default next">
                                    <span class="glyphicon glyphicon-forward"/>
                                </button>
                                <button type="button" class="btn btn-default last">
                                    <span class="glyphicon glyphicon-step-forward"/>
                                </button>
                            </div>
                            <select class="form-control input-sm pagesize" title="Select page size">
                                <option selected="selected" value="10">10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="all">All Rows</option>
                            </select>
                            <select class="form-control input-sm pagenum" title="Select page number"/>
                        </th>
                    </tr>
                </tfoot>
                </table>
};




declare function search:search_simple_old($node as node(), $model as map(*)) {
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

declare function search:search_simple($node as node(), $model as map(*)) {
<table class="table table-striped">
        {
        for $mss in collection($config:data-root || "/msDescs")
        let $ms := $mss/tei:TEI        
        let $title := $ms//tei:titleStmt/tei:title
        let $uri := concat('/ms/', replace(base-uri($mss), '.+/(.+)$', '$1'))
        let $query := request:get-parameter('q', '')
        return
        for $hit in $ms[ft:query(., $query)]                                
                order by $title ascending 
                return                
                    <tr>                    
                        <td><a href="{substring-before($uri, '.xml')}">{$title}</a></td>
                        <td>{kwic:summarize($hit, <config xmlns="" width="100"/>)}</td>                        
                    </tr>
         }
         </table>
};
