<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="addName">
        <div>
            <span class="head">Additional name: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="forename">
        <div>
            <span class="head">Forename: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="genName">
        <div>
            <span class="head">Generational name: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="idno">
        <xsl:choose>
            <xsl:when test="parent::person">
                <div>
                    <span class="head">
                        <xsl:value-of select="@subtype"/>: </span>
                    <a href="{.}">
                        <xsl:value-of select="."/>
                    </a>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <span class="head">Manuscripta ID: </span>
                    <xsl:value-of select="substring-after(., '/person/')"/>
                </div>
                <div>
                    <span class="head">Permalink: </span>
                    <xsl:value-of select="."/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="nameLink">
        <div>
            <span class="head">Name link: </span>
            <xsl:value-of select="."/>
        </div>
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
    <xsl:template match="persName">
        <xsl:choose>
            <xsl:when test="parent::person">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                    <xsl:value-of select="normalize-space(.)"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="roleName">
        <div>
            <span class="head">Role name: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="surname">
        <div>
            <span class="head">Surname: </span>
            <xsl:value-of select="."/>
        </div>
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