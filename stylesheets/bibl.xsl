<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="starts-with(//biblStruct//idno[1], 'https://books.google.se/books?id=')">
                <h3 id="{data(//biblStruct//idno[1])}" class="page-header">
                    <xsl:value-of select="//titleStmt/title"/>
                </h3>
            </xsl:when>
            <xsl:when test="starts-with(//biblStruct//idno[1], 'https://archive.org/details/')">
                <h3 id="{data(//biblStruct//idno[1])}" class="page-header">
                    <xsl:value-of select="//titleStmt/title"/>
                </h3>
            </xsl:when>
            <xsl:otherwise>
                <h3 class="page-header">
                    <xsl:value-of select="//titleStmt/title"/>
                </h3>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="//author"/>
        <xsl:if test="exists(//analytic/title[@level = 'a'])">
            <div>
                <span class="head">Article title: </span>
                <xsl:value-of select="//title[@level = 'a']"/>
            </div>
        </xsl:if>
        <xsl:if test="exists(//monogr/title[@level = 'm'])">
            <div>
                <span class="head">Monograph title: </span>
                <xsl:choose>
                    <xsl:when test="exists(//monogr/title/@ref)">
                        <a href="{data(replace(//monogr/title/@ref, 'www', 'test'))}">
                            <xsl:value-of select="//monogr/title[@level = 'm']"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//monogr/title[@level = 'm']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="exists(//series/title[@level = 's'])">
            <div>
                <span class="head">Series title: </span>
                <a href="{data(replace(//series/title/@ref, 'www', 'test'))}">
                    <xsl:value-of select="//series/title[@level = 's']"/>
                </a>
            </div>
        </xsl:if>
        <xsl:apply-templates select="//editor"/>

        <xsl:if test="exists(//monogr/title[@level = 'j'])">
            <div>
                <span class="head">Journal title: </span>
                <xsl:choose>
                    <xsl:when test="exists(//monogr/title/@ref)">
                        <a href="{data(replace(//monogr/title/@ref, 'www', 'test'))}">
                            <xsl:value-of select="//monogr/title[@level = 'j']"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//monogr/title[@level = 'j']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="exists(//pubPlace)">
            <div>
                <span class="head">Publication place: </span>
                <a href="{data(replace(//imprint/pubPlace/@ref, 'www', 'test'))}">
                    <xsl:value-of select="//imprint/pubPlace"/>
                </a>
            </div>
        </xsl:if>
        <xsl:if test="exists(//imprint/date)">
            <div>
                <span class="head">Publication year: </span>
                <xsl:choose>
                    <xsl:when test="exists(//imprint/date/@from)">
                        <xsl:value-of select="//imprint/date/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//imprint/date/@to"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//imprint/date/@when"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="exists(//biblScope[@unit = 'volume'])">
            <div>
                <xsl:choose>
                    <xsl:when test="//biblScope[@unit = 'volume']/@from = //biblScope[@unit = 'volume']/@to">
                        <span class="head">Volume: </span>
                        <xsl:value-of select="//biblScope[@unit = 'volume']/@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="head">Volumes: </span>
                        <xsl:value-of select="//biblScope[@unit = 'volume']/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//biblScope[@unit = 'volume']/@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="exists(//biblScope[@unit = 'issue'])">
            <div>
                <xsl:choose>
                    <xsl:when test="//biblScope[@unit = 'issue']/@from = //biblScope[@unit = 'issue']/@to">
                        <span class="head">Issue: </span>
                        <xsl:value-of select="//biblScope[@unit = 'issue']/@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="head">Issues: </span>
                        <xsl:value-of select="//biblScope[@unit = 'issue']/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//biblScope[@unit = 'issue']/@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="exists(//biblScope[@unit = 'column'])">
            <div>
                <xsl:choose>
                    <xsl:when test="//biblScope[@unit = 'column']/@from = //biblScope[@unit = 'column']/@to">
                        <span class="head">Column: </span>
                        <xsl:value-of select="//biblScope[@unit = 'column']/@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="head">Columns: </span>
                        <xsl:value-of select="//biblScope[@unit = 'column']/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//biblScope[@unit = 'column']/@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="exists(//biblScope[@unit = 'folio'])">
            <div>
                <xsl:choose>
                    <xsl:when test="//biblScope[@unit = 'folio']/@from = //biblScope[@unit = 'folio']/@to">
                        <span class="head">Folio: </span>
                        <xsl:value-of select="//biblScope[@unit = 'folio']/@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="head">Folios: </span>
                        <xsl:value-of select="//biblScope[@unit = 'folio']/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//biblScope[@unit = 'folio']/@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="exists(//biblScope[@unit = 'page'])">
            <div>
                <span class="head">Pages: </span>
                <span id="startPage">
                    <xsl:value-of select="//biblScope[@unit = 'page']/@from"/>
                </span>
                <xsl:text>–</xsl:text>
                <xsl:value-of select="//biblScope[@unit = 'page']/@to"/>
            </div>
        </xsl:if>

        <xsl:call-template name="footer"/>

    </xsl:template>

    <xsl:template match="author">
        <xsl:choose>
            <xsl:when test="@role = 'origAuth'">
                <div>
                    <span class="head">Author (original): </span>
                    <a href="{data(replace(persName/@ref, 'www', 'test'))}">
                        <xsl:value-of select=".[@role = 'origAuth']/persName"/>
                    </a>
                </div>
            </xsl:when>
            <xsl:when test="@role = 'critEd'">
                <div>
                    <span class="head">Author (critical editor): </span>
                    <a href="{data(replace(persName/@ref, 'www', 'test'))}">
                        <xsl:value-of select=".[@role = 'critEd']/persName"/>
                    </a>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <span class="head">Author: </span>
                    <xsl:choose>
                        <xsl:when test="exists(persName)">
                            <a href="{data(replace(persName/@ref, 'www', 'test'))}">
                                <xsl:value-of select="persName"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="editor">
        <div>
            <span class="head">Editor: </span>
            <a href="{data(replace(persName/@ref, 'www', 'test'))}">
                <xsl:choose>
                    <xsl:when test="persName">
                        <xsl:value-of select="persName"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </div>
    </xsl:template>

    <xsl:template name="footer">
        <div>
            <div>
                <span class="head">Manuscripta ID: </span>
                <xsl:value-of select="/TEI/@xml:id"/>
            </div>
            <div>
                <span class="head">Stable URI: </span>
                <xsl:value-of select="//publicationStmt/idno[@subtype = 'Manuscripta']"/>
            </div>
            <div>
                <span class="head">XML: </span>
                <a href="/bibl/{data(substring-after(TEI/@xml:id, 'bibl-'))}.xml">
                    <xsl:text>https://www.manuscripta.se/bibl/</xsl:text>
                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'bibl-'))"/>
                    <xsl:text>.xml</xsl:text>
                </a>
            </div>
            <div>
                <span class="head">License: </span>
                <a rel="license" href="https://creativecommons.org/publicdomain/zero/1.0/">CC0 1.0 Universal</a>
            </div>
            <div>
                <span class="head">Last revision: </span>
                <xsl:value-of select="//change/@when"/>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>