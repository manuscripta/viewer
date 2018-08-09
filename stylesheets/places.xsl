<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="idno">
        <xsl:choose>
            <xsl:when test="parent::place">
                <div>
                    <span class="head">
                        <xsl:if test="@subtype = 'geonames'">
                            <xsl:text>Geonames: </xsl:text>
                        </xsl:if>
                        <xsl:if test="@subtype = 'Wikidata'">
                            <xsl:text>Wikidata: </xsl:text>
                        </xsl:if>
                    </span>
                    <a href="{.}">
                        <xsl:value-of select="."/>
                    </a>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <span class="head">Manuscripta ID: </span>
                    <xsl:value-of select="substring-after(., '/place/')"/>
                </div>
                <div>
                    <span class="head">Permalink: </span>
                    <xsl:value-of select="."/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="note">
        <xsl:if test="@xml:lang = 'en'">
            <div>
                <span class="head">Note: </span>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
        <xsl:if test="@xml:lang = 'sv'">
            <div>
                <span class="head">Anteckning: </span>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="placeName">
        <xsl:if test="@xml:lang = 'en'">
            <div>
                <span class="head">Place name (English): </span>
                <xsl:value-of select="."/>
            </div>
        </xsl:if>
        <xsl:if test="@xml:lang = 'sv'">
            <div>
                <span class="head">Place name (Swedish): </span>
                <xsl:value-of select="."/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="title">
        <h3 class="page-header">
            <xsl:value-of select="//titleStmt/title"/>
        </h3>
    </xsl:template>
    <xsl:template match="avalibility"/>
    <xsl:template match="licence"/>
    <xsl:template match="publisher"/>
    <xsl:template match="respStmt"/>
    <xsl:template match="revisionDesc"/>
    <xsl:template match="sourceDesc"/>
</xsl:stylesheet>