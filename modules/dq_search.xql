xquery version "3.0";

(:~ ================================================
    Implements the documentation search.
    ================================================ :)
module namespace dq="http://exist-db.org/xquery/documentation/search";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";

import module namespace kwic="http://exist-db.org/xquery/kwic";

declare namespace templates="http://exist-db.org/xquery/templates";

declare option exist:serialize "method=html media-type=text/html expand-xincludes=yes";



declare variable $dq:CHARS_SUMMARY := 3000;
declare variable $dq:CHARS_KWIC := 800;

(:~
    Templating function: process the query.
:)
declare 
    %public %templates:default("field", "all") %templates:default("view", "summary")
function dq:query($node as node()*, $model as map(*), $q as xs:string?, $field as xs:string, $view as xs:string) {
	if ($q) then
		let $hits := dq:do-query(collection("/db/apps/manuscripta.se/data/msDescs"), $q, $field)
		let $search-params :=
            string-join(
                map-pairs(function($k, $v) { $k || "=" || $v }, ("q", "field"), ($q, $field)),
                "&amp;"
            )
		return
            <div id="f-search">
			{dq:print-results($hits, $search-params, $view)}
            </div>
	else
		()
};

(:~
	Display the hits: this function iterates through all hits and calls
	kwic:summarize to print out a summary of each match.
:)
declare %private function dq:print($hit as element(), $search-params as xs:string, $mode as xs:string)
as element()* {
    let $nodeId := util:node-id($hit)
	let $uri := util:document-name(root($hit)) || "?" ||
		$search-params || "&amp;id=D" || $nodeId || "#D" || $nodeId
	let $config :=
		<config xmlns="" width="{if ($mode eq 'summary') then $dq:CHARS_SUMMARY else $dq:CHARS_KWIC}"
			table="{if ($mode eq 'summary') then 'no' else 'yes'}"
			link="{$uri}"/>
    let $matches := kwic:get-matches($hit)
    for $ancestor in ($matches/ancestor::tei:msItem/tei:title)
    return
        kwic:get-summary($ancestor, ($ancestor//exist:match)[1], $config) 
};

(:~
	Print the hierarchical context of a hit.
:)
declare %private function dq:print-headings($section as element()*, $search-params as xs:string) {
	let $log := util:log("DEBUG", ("##$search-paramsxxx): ", $search-params))
	let $nodeId := util:node-id($section)
	let $uri :=
		util:document-name(root($section)) || "?" || $search-params || "&amp;id=D" || $nodeId
		return
		  <a href="{$uri}">{$section/ancestor-or-self::tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/text()}</a>,
	for $s at $p in $section/ancestor-or-self::tei:msItem
	let $nodeId := util:node-id($s)
	let $uri :=
		util:document-name(root($s)) || "?" || $search-params || "&amp;id=D" || $nodeId || "#D" || $nodeId
	return
		(" > ", <a href="{$uri}">{$s/tei:title/text()}</a>)
};

(:~
	Display the query results.
:)
declare %private function dq:print-results($hits as element()*, $search-params as xs:string, $mode as xs:string) {
		<div id="f-results">
			<p class="heading">Found {count($hits)} result{
    		 if (count($hits) eq 1) then "" else "s"}.</p>
			{
				if ($mode eq 'summary') then
					for $section in $hits
					let $score := ft:score($section)
					order by $score descending
					return
					    <div class="section">
					        <span class="score">Score: {round-half-to-even($score, 2)}</span>
							<div class="headings">{ dq:print-headings($section, $search-params) }</div>
							{ dq:print($section, $search-params, $mode) }
						</div>
				else
					<table class="kwic">
					{
						for $section in $hits
						order by ft:score($section) descending
						return (
							<tr>
								<td class="headings" colspan="3">
								{dq:print-headings($section, $search-params)}
								</td>
							</tr>,
							dq:print($section, $search-params, $mode)
						)
					}
					</table>
			}
		</div>
};

declare %public function dq:do-query($context as node()*, $query as xs:string, $field as xs:string) {
    if (count($context) > 1) then
        switch ($field)
            case "title" return
                $context//tei:title[ft:query(.//tei:msItem, $query)]
            default return
                $context//tei:title[ft:query(.//tei:msItem, $query)] | $context//tei:title[ft:query(., $query)][not(tei:title)]
    else
        switch ($field)
            case "title" return
                $context//tei:title[ft:query(.//tei:msItem, $query)]
            default return
                $context[.//tei:title[ft:query(.//tei:msItem, $query)] or .//tei:title[ft:query(., $query)][not(tei:title)]]
};