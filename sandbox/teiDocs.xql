xquery version "3.0";

import module namespace teiDocs = "http://nullable.net/teiDocs" at "/db/apps/teiDocs/teiDocs.xqm";

declare option exist:serialize "method=html5 media-type=text/html";

teiDocs:generate-docs("/db/apps/manuscripta.se/data/xml/cug27.xml")