xquery version "3.0";

declare namespace editor="http://www.manuscripta.se/xquery/editor";
declare namespace tei="http://www.tei-c.org/ns/1.0";
import module namespace config="http://www.manuscripta.se/xquery/config" at "config.xqm";
import module namespace view="http://www.manuscripta.se/xquery/view" at "view_msDesc.xql";


declare function editor:get-preview() {
	let $data := request:get-data()
	let $doc := $data/tei:TEI
	return <div class="container-msdesc">{view:view-msDesc-html($doc)}</div>
};


let $action := request:get-parameter('action', '')
return
if ($action eq 'get-preview') then
	editor:get-preview()
else error(xs:QName("editor:error"), 'Invalid action')

