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

else if (starts-with($exist:path, "/uub")) then
    let $id := $exist:resource
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
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
    
else if ($exist:path eq "/bibliography") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/bibliography.html")}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if ($exist:path eq "/guidelines") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/guidelines.html")}"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
    </dispatch>
    
else if (starts-with($exist:path, "/bibliography")) then
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
    </dispatch>

else if ($exist:path eq "/search") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, "/search.html")}"/>
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

else if ($exist:path eq "/contact") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/contact.html"/>
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

else if ($exist:path eq "/browse/authors") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/authors.html"/>
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

else if ($exist:path eq "/browse/scribes") then    
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/scribes.html"/>
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
