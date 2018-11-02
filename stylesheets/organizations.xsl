<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>

    <xsl:template match="/">
        <xsl:apply-templates/>        
    </xsl:template>

    <xsl:template match="org/idno">
        <div>
            <span class="head">
                <xsl:value-of select="@subtype"/>: </span>
            <a href="{.}">
                <xsl:value-of select="."/>
            </a>
        </div>
    </xsl:template>    
    <xsl:template match="desc">
        <xsl:if test="@xml:lang = 'en'">
            <div>
                <span class="head">Description: </span>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
        <xsl:if test="@xml:lang = 'sv'">
            <div>
                <span class="head">Beskrivning: </span>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="orgName">
        <xsl:choose>
            <xsl:when test="parent::org">
                <xsl:if test="@xml:lang = 'en'">
                    <div>
                        <span class="head">Name of organization (English): </span>
                        <xsl:value-of select=".[@xml:lang = 'en']"/>
                    </div>
                </xsl:if>
                <xsl:if test="@xml:lang = 'sv'">
                    <div>
                        <span class="head">Name of organization (Swedish): </span>
                        <xsl:value-of select=".[@xml:lang = 'sv']"/>
                    </div>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                    <xsl:value-of select="normalize-space(.)"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="title">
        <h3 class="page-header">
            <xsl:value-of select="//titleStmt/title"/>
        </h3>
    </xsl:template>
    
    <xsl:template match="publicationStmt"/>
    <xsl:template match="respStmt"/>
    <xsl:template match="revisionDesc"/>
    <xsl:template match="sourceDesc"/>

</xsl:stylesheet>