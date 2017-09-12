<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>
    <xsl:template match="/">
        <h3 class="page-header">
            <xsl:value-of select="//titleStmt/title"/>
        </h3>
        <div>
            <span class="head">Forename: </span>
            <xsl:value-of select="//person/persName/forename"/>
        </div>
        <div>
            <span class="head">Surname: </span>
            <xsl:value-of select="//person/persName/surname"/>
        </div>
        <xsl:if test="//person/idno[@subtype = 'VIAF']">
            <div>
                <span class="head">VIAF: </span>
                <a href="{data(//idno[@subtype='VIAF'])}">
                    <xsl:value-of select="//idno[@subtype = 'VIAF']"/>
                </a>
            </div>
        </xsl:if>
        <xsl:if test="//person/idno[contains(., 'wikipedia')]">
            <div>
                <xsl:variable name="wikipedia" select="//person/idno[contains(., 'wikipedia')]"/>
                <span class="head">Wikipedia: </span>
                <a href="{data($wikipedia)}">
                    <xsl:value-of select="$wikipedia"/>
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