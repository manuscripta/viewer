xquery version "3.0";

declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xslfo = "http://exist-db.org/xquery/xslfo";
(:~
 : View play as html, pdf or xml 
 : Uses transform:transform() for xsl conversion
 : Uses xslfo:render for xslfo conversion
 : You must use response:stream-binary to output pdf to browser
 : @author Winona Salesky
 : @version 0.1
:)
(:~ 
 : Parameters passed from the url 
 : @param $id passes internal id for play
 : @param $view view used for output
 :)
declare variable $uri {request:get-parameter('uri', '')};
declare variable $view {request:get-parameter('view', '')};

let $rec := xmldb:document($uri)
return 
    if($view = 'html') then transform:transform($rec, doc('../data/stylesheets/tei2html.xsl'),() )
    else if($view = 'pdf') then 
        let $pdf:= xslfo:render(transform:transform($rec, doc('../data/stylesheets/tei2pdf.xsl'),()),'application/pdf', ())
        return
             response:stream-binary($pdf, "application/pdf", "output.pdf")
    else $rec/child::*