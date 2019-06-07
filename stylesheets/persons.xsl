<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
        <xsl:call-template name="footer"/>
    </xsl:template>
    <xsl:template match="addName">
        <div>
            <h6>Additional name: </h6>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="birth">
        <div>
            <h6>Birth: </h6>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="death">
        <div>
            <h6>Death: </h6>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="forename">
        <div>
            <h6>Forename: </h6>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="genName">
        <div>
            <h6>Generational name: </h6>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    <xsl:template match="idno">
        <xsl:choose>
            <xsl:when test="parent::person">
                <div>
                    <h6>
                        <xsl:value-of select="@subtype"/>: </h6>
                    <a href="{.}">
                        <xsl:value-of select="."/>
                    </a>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="nameLink">
        <div>
            <h6>Name link: </h6>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="note">
        <xsl:if test="@xml:lang = 'en'">
            <div>
                <h6>Note: </h6>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
        <xsl:if test="@xml:lang = 'sv'">
            <div>
                <h6>Anteckning: </h6>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="occupation">
        <div>
            <h6>Occupation: </h6>
            <xsl:apply-templates/>
        </div>
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
    
    <xsl:template match="residence">
        <div>
            <h6>Residence: </h6>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="roleName">
        <div>
            <h6>Role name: </h6>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="surname">
        <div>
            <h6>Surname: </h6>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="title">
        <h3 class="page-header">
            <xsl:value-of select="//titleStmt/title"/>
        </h3>
    </xsl:template>

    <xsl:template name="footer">
        <div>
            <div>
                <h6>Manuscripta ID: </h6>
                <xsl:value-of select="/TEI/@xml:id"/>
            </div>
            <div>
                <h6>Stable URI: </h6>
                <xsl:value-of select="//publicationStmt/idno[@subtype = 'Manuscripta']"/>
            </div>
            <div>
                <h6>XML: </h6>
                <a href="/person/{data(substring-after(TEI/@xml:id, 'person-'))}.xml">
                    <xsl:text>https://www.manuscripta.se/person/</xsl:text>
                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'person-'))"/>
                    <xsl:text>.xml</xsl:text>
                </a>
            </div>
            <div>
                <h6>License: </h6>
                <a rel="license" href="https://creativecommons.org/publicdomain/zero/1.0/">CC0 1.0 Universal</a>
            </div>
            <div>
                <h6>Last revision: </h6>
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