<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>

    <xsl:include href="templates.xsl"/>

    <xsl:template match="/">
        <div class="bibliography">
            <xsl:apply-templates select="//bibl"/>    
        </div>
    </xsl:template>    
</xsl:stylesheet>