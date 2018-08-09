xquery version "3.1";
let $template := doc("/db/apps/manuscripta-dev/stylesheets/tei2html_template.xsl")
let $stylesheet := doc("/db/apps/manuscripta-dev/stylesheets/template2xsl_en.xsl")
return
transform:transform($template, $stylesheet, ())