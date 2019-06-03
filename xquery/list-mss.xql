xquery version "3.1";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

<mss>
{for $ms in collection('/db/apps/manuscripta-dev/data/msDescs')
let $shelfmark := $ms//tei:msIdentifier/tei:idno[@type='shelfmark']
let $ManuscriptaID := $ms//tei:TEI/substring-after(@xml:id, 'ms-')
order by $ManuscriptaID
return 
    <ms>
        <shelfmark>{data($shelfmark)}</shelfmark>
        <ManuscriptaID>{data($ManuscriptaID)}</ManuscriptaID>
    </ms>
    }
</mss>