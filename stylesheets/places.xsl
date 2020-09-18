<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
        <xsl:call-template name="footer"/>
    </xsl:template>

    <xsl:template match="idno">
        <xsl:choose>
            <xsl:when test="parent::place">
                <div>
                    <label>
                        <xsl:value-of select="@subtype"/>: </label>
                    <a href="{.}">
            <xsl:value-of select="."/>
        </a>
        </div>                
            </xsl:when>            
        </xsl:choose>
    </xsl:template>

    <xsl:template match="note">
        <xsl:if test="@xml:lang = 'en'">
            <div>
            <label>Note: </label>
            <xsl:apply-templates/>
        </div>
        </xsl:if>
        <xsl:if test="@xml:lang = 'sv'">
            <div>
            <label>Anteckning: </label>
            <xsl:apply-templates/>
        </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="placeName">
        <xsl:if test="@xml:lang = 'en'">
            <div>
                <label>Place name (English): </label>
                <xsl:value-of select="."/>
            </div>
        </xsl:if>
        <xsl:if test="@xml:lang = 'sv'">
            <div>
            <label>Place name (Swedish): </label>
            <xsl:value-of select="."/>
        </div>
        </xsl:if>
            </xsl:template>

    <xsl:template match="title">
        <h1 class="page-header">
            <xsl:value-of select="//titleStmt/title"/>
        </h1>
    </xsl:template>

    <xsl:template name="footer">
        <div>
            <div>
                <label>Manuscripta ID: </label>
                <xsl:value-of select="/TEI/@xml:id"/>
            </div>
            <div>
                <label>Stable URI: </label>
                <xsl:value-of select="//publicationStmt/idno[@subtype = 'Manuscripta']"/>
            </div>
            <div>
                <label>XML: </label>
                <a href="/place/{data(substring-after(TEI/@xml:id, 'place-'))}.xml">
                    <xsl:text>https://www.manuscripta.se/place/</xsl:text>
                <xsl:value-of select="data(substring-after(TEI/@xml:id, 'place-'))"/>
                    <xsl:text>.xml</xsl:text>
                </a>
            </div>
        <div>
        <label>License: </label>
            <a rel="license" href="https://creativecommons.org/publicdomain/zero/1.0/">CC0 1.0 Universal</a>
            </div>
            <div>
                <label>Last revision: </label>
                <xsl:value-of select="//change/@when"/>
            </div>
        </div>
    </xsl:template>
<xsl:template match="avalibility"/>

    <xsl:template match="funder"/>

    <xsl:template match="licence"/>

    <xsl:template match="publisher"/>

    <xsl:template match="respStmt"/>

    <xsl:template match="revisionDesc"/>

    <xsl:template match="sourceDesc"/>

    <xsl:template match="sponsor"/>
</xsl:stylesheet>