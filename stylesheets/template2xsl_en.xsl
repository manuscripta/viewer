<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msg="urn:x-kosek:schemas:messages:1.0" exclude-result-prefixes="msg" version="1.0">

    <xsl:output method="xml" />

    <xsl:param name="lang">en</xsl:param>

    <xsl:param name="messages" select="document(concat($lang, '.xml'))/l" />

    <!-- Copy stylesheet untouched -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <!-- Replace msg:* elements with corresponding entry from message catalog -->
    <xsl:template match="msg:*" priority="1">
        <xsl:element name="xsl:text">
            <xsl:value-of select="$messages/text[@key = local-name(current())]" />    
        </xsl:element>        
    </xsl:template>

</xsl:stylesheet>
