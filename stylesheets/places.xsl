<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>
    <xsl:template match="/">
        <h3 class="page-header">
            <xsl:value-of select="//titleStmt/title"/>
        </h3>
        <div>
            <span class="head">ID: </span>
            <xsl:value-of select="substring-after(//place/@xml:id, 'place-')"/>
        </div>
        <div>
            <span class="head">URI: </span>
            <xsl:value-of select="//publicationStmt/idno"/>
        </div>
        <xsl:for-each select="//placeName">
            <div>
                <span class="head">Name (<xsl:value-of select="@xml:lang"/>): </span>
                <xsl:value-of select="."/>
            </div>
        </xsl:for-each>
        <div>
            <span class="head">Type: </span>
            <xsl:value-of select="//place/@type"/>
        </div>
        <xsl:if test="exists(//place/idno)">
            <div>
                <span class="head">Geonames: </span>
                <a href="{data(//idno[@subtype='geonames'])}">
                    <xsl:value-of select="//idno[@subtype = 'geonames']"/>
                </a>
            </div>
        </xsl:if>
        <xsl:if test="exists(//note)">
            <div>
                <span class="head">Note: </span>
                <xsl:value-of select="//note"/>
            </div>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>