<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>

    <xsl:include href="templates.xsl"/>

    <xsl:template match="/">
        <h3 class="page-header">
            <xsl:choose>
                <xsl:when test="exists(//title[@level='m'])">
                    <xsl:value-of select="//title[@level='m']"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="//title[@level='a']"/>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
        <xsl:choose>
            <xsl:when test="exists(//author[@role='origAuth'])">
                <div>
                    <span class="head">Author (original): </span>
                    <xsl:apply-templates select="//author[@role='origAuth']/persName"/>
                </div>
                <div>
                    <span class="head">Author (critical editor): </span>
                    <xsl:apply-templates select="//author[@role='critEd']/persName"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <span class="head">Author: </span>
                    <xsl:apply-templates select="//persName"/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="exists(//title[@level='s'])">
            <div>
                <span class="head">Series: </span>
                <xsl:apply-templates select="//title[@level='s']"/>
            </div>
        </xsl:if>
        <div>
            <span class="head">Published: </span>
            <xsl:apply-templates select="//pubPlace"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="//date"/>
        </div>
        <xsl:if test="exists(//biblScope)">
            <div>
                <span class="head">Scope: </span>
                <xsl:apply-templates select="//biblScope"/>
            </div>
        </xsl:if>
        

    </xsl:template>

</xsl:stylesheet>