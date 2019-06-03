xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

(:let $query := request:get-parameter("q", ())
return:)
if ($exist:path eq "") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>
    
else if ($exist:path eq "/") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="index.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

(: Resource paths starting with $shared are loaded from the shared-resources app :)
else if (contains($exist:path, "/$shared/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}">
            <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
        </forward>
    </dispatch>

(: Resources must be placed before other rules in order that stylesheets work :)
else if (contains($exist:path, "resources/")) then
    let $resourcePath := substring-after($exist:path, "resources/")
    let $url := $exist:controller || '/resources/' || $resourcePath
    return
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$url}">
                <cache-control cache="yes"/>
            </forward>
        </dispatch>

(:else if (starts-with($exist:path, ("/uub", "/lub", "/lsb", "/kb", "/gub", "/ra", "/skokl", "/nm", "/ms/"))) then:)
else if (matches($exist:path, '^/ms/\d+$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
<!--  <forward url="{$exist:controller}/view_sv.html"/>-->
        <forward url="{$exist:controller}/view.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="id" value="{$id}.xml"/>
            </forward>
        </view>
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (matches($exist:path, '^/person/\d+$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/view_person.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="person" value="{$id}.xml"/>
            </forward>
        </view>
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (matches($exist:path, '^/place/\d+$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/view_place.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="place" value="{$id}.xml"/>
            </forward>
        </view>
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (matches($exist:path, '^/bibl/\d+$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/view_bibl.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="bibl" value="{$id}.xml"/>
            </forward>
        </view>
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (matches($exist:path, '^/org/\d+$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/view_org.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="org" value="{$id}.xml"/>
            </forward>
        </view>
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (matches($exist:path, '^/work/\d+$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/view_work.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="work" value="{$id}.xml"/>
            </forward>
        </view>
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
(:else if (matches($exist:path, '^/xml/\d+$')) then:)
else if (matches($exist:path, '^/ms/\d+\.xml$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/data/msDescs/{$id}"/>        
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
    else if (matches($exist:path, '^/bibl/\d+\.xml$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/data/id/bibl/{$id}"/>        
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
    else if (matches($exist:path, '^/org/\d+\.xml$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/data/id/org/{$id}"/>        
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
    else if (matches($exist:path, '^/person/\d+\.xml$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/data/id/person/{$id}"/>        
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if (matches($exist:path, '^/place/\d+\.xml$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/data/id/place/{$id}"/>        
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>

else if (matches($exist:path, '^/work/\d+\.xml$')) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/data/id/work/{$id}"/>        
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>


else if ($exist:path eq "/guidelines") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/guidelines.html")}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
    else if ($exist:path eq "/editor") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/editor.html")}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
(:else if (starts-with($exist:path, "/bibliography")) then
    let $item := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/view_biblItem.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="item" value="{$item}"/>
            </forward>
        </view>
        <error-handler>
	<forward url="{$exist:controller}/404.html" method="get"/>
	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>:)

else if ($exist:path eq "/search") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/search.html")}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if ($exist:path eq "/sok") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/sok.html")}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
   
else if ($exist:path eq "/results") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/results.html")}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/resultat") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/resultat.html")}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/contact") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/contact.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/kontakt") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/kontakt.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/sv") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/index_sv.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/greek") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/greek_manuscripts.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if ($exist:path eq "/grekiska") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/grekiska_handskrifter.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/swedish") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/old_swedish_manuscripts.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/fornsvenska") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/fornsvenska_handskrifter.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/browse/manuscripts") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/manuscripts.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if ($exist:path eq "/browse/manuscripts/greek") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/manuscripts-greek.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if ($exist:path eq "/browse/manuscripts/swedish") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/manuscripts-swedish.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if ($exist:path eq "/bladdra/handskrifter") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/handskrifter.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/browse/authors") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/authors.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if ($exist:path eq "/bladdra/forfattare") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/forfattare.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/browse/incipits") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/incipits.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/bladdra/incipit") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/incipit.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>

else if ($exist:path eq "/browse/scribes") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/scribes.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if ($exist:path eq "/mirador") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/mirador.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
    else if ($exist:path eq "/mirador_greek") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/mirador_greek.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
    else if ($exist:path eq "/mirador_ttt") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/mirador_ttt.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
    else if ($exist:path eq "/KB-medeltida") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/KB-medeltida.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if (ends-with($exist:resource, ".html")) then
    (: the html page is run through view.xql to expand templates :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
        <error-handler>
        	<forward url="{$exist:controller}/404.html" method="get"/>
        	<forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
        </dispatch>

else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
