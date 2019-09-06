<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="starts-with(//biblStruct//idno[1], 'https://books.google.se/books?id=')">
                <h2 id="{data(//biblStruct//idno[1])}" class="page-header">
                    <xsl:value-of select="//titleStmt/title"/>
                </h2>
            </xsl:when>
            <xsl:when test="starts-with(//biblStruct//idno[1], 'https://archive.org/details/')">
                <h2 id="{data(//biblStruct//idno[1])}" class="page-header">
                    <xsl:value-of select="//titleStmt/title"/>
                </h2>
            </xsl:when>
            <xsl:otherwise>
                <h2 class="page-header">
                    <xsl:value-of select="//titleStmt/title"/>
                </h2>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="//author"/>
        <xsl:if test="//analytic/title[@level = 'a']">
            <div>
                <label>Article title: </label>
                <xsl:value-of select="//title[@level = 'a']"/>
            </div>
        </xsl:if>
        <xsl:if test="//monogr/title[@level = 'm']">
            <div>
                <label>Monograph title: </label>
                <xsl:choose>
                    <xsl:when test="//monogr/title/@ref">
                        <a href="../{data(substring-after(//monogr/title/@ref, 'https://www.manuscripta.se/'))}">
                            <xsl:value-of select="//monogr/title[@level = 'm']"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//monogr/title[@level = 'm']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="//series/title[@level = 's']">
            <div>
                <label>Series title: </label>
                <xsl:choose>
                    <xsl:when test="//monogr/title/@ref">
                        <a href="../{data(substring-after(//monogr/title/@ref, 'https://www.manuscripta.se/'))}">
                            <xsl:value-of select="//monogr/title[@level = 's']"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//monogr/title[@level = 's']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:apply-templates select="//editor"/>

        <xsl:if test="//monogr/title[@level = 'j']">
            <div>
                <label>Journal title: </label>
                <xsl:choose>
                    <xsl:when test="//monogr/title/@ref">
                        <a href="../{data(substring-after(//monogr/title/@ref, 'https://www.manuscripta.se/'))}">
                            <xsl:value-of select="//monogr/title[@level = 'j']"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//monogr/title[@level = 'j']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="//pubPlace">
            <div>
                <label>Publication place: </label>
                <a href="../{data(substring-after(//imprint/pubPlace/@ref, 'https://www.manuscripta.se/'))}">
                    <xsl:value-of select="//imprint/pubPlace"/>
                </a>
            </div>
        </xsl:if>
        <xsl:if test="//imprint/date">
            <div>
                <label>Publication year: </label>
                <xsl:choose>
                    <xsl:when test="//imprint/date/@from">
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
        <xsl:if test="//biblScope[@unit = 'volume']">
            <div>
                <xsl:choose>
                    <xsl:when test="//biblScope[@unit = 'volume']/@from = //biblScope[@unit = 'volume']/@to">
                        <label>Volume: </label>
                        <xsl:value-of select="//biblScope[@unit = 'volume']/@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <label>Volumes: </label>
                        <xsl:value-of select="//biblScope[@unit = 'volume']/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//biblScope[@unit = 'volume']/@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="//biblScope[@unit = 'issue']">
            <div>
                <xsl:choose>
                    <xsl:when test="//biblScope[@unit = 'issue']/@from = //biblScope[@unit = 'issue']/@to">
                        <label>Issue: </label>
                        <xsl:value-of select="//biblScope[@unit = 'issue']/@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <label>Issues: </label>
                        <xsl:value-of select="//biblScope[@unit = 'issue']/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//biblScope[@unit = 'issue']/@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="//biblScope[@unit = 'column']">
            <div>
                <xsl:choose>
                    <xsl:when test="//biblScope[@unit = 'column']/@from = //biblScope[@unit = 'column']/@to">
                        <label>Column: </label>
                        <xsl:value-of select="//biblScope[@unit = 'column']/@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <label>Columns: </label>
                        <xsl:value-of select="//biblScope[@unit = 'column']/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//biblScope[@unit = 'column']/@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="//biblScope[@unit = 'folio']">
            <div>
                <xsl:choose>
                    <xsl:when test="//biblScope[@unit = 'folio']/@from = //biblScope[@unit = 'folio']/@to">
                        <label>Folio: </label>
                        <xsl:value-of select="//biblScope[@unit = 'folio']/@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <label>Folios: </label>
                        <xsl:value-of select="//biblScope[@unit = 'folio']/@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//biblScope[@unit = 'folio']/@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
        <xsl:if test="//biblScope[@unit = 'page']">
            <div>
                <label>Pages: </label>
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
                    <label>Author (original): </label>
                    <xsl:choose>
                        <xsl:when test="persName/@ref">
                            <a href="../{data(substring-after(persName/@ref, 'https://www.manuscripta.se/'))}">
                                <xsl:value-of select="normalize-space(.)"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--<a href="{data(replace(persName/@ref, 'www', 'dev'))}">
                        <xsl:value-of select=".[@role = 'origAuth']/persName" />
                    </a>-->
                </div>
            </xsl:when>
            <xsl:when test="@role = 'critEd'">
                <div>
                    <label>Author (critical editor): </label>
                    <xsl:choose>
                        <xsl:when test="persName/@ref">
                            <a href="../{data(substring-after(persName/@ref, 'https://www.manuscripta.se/'))}">
                                <xsl:value-of select="normalize-space(.)"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--<a href="{data(replace(persName/@ref, 'www', 'dev'))}">
                        <xsl:value-of select=".[@role = 'critEd']/persName" />
                    </a>-->
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <label>Author: </label>
                    <xsl:choose>
                        <xsl:when test="persName/@ref">
                            <a href="../{data(substring-after(persName/@ref, 'https://www.manuscripta.se/'))}">
                                <xsl:value-of select="normalize-space(.)"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--<xsl:choose>
                        <xsl:when test="exists(persName)">
                            <a href="{data(replace(persName/@ref, 'www', 'dev'))}">
                                <xsl:value-of select="persName"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>-->
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="editor">
        <div>
            <label>Editor: </label>
            <xsl:choose>
                <xsl:when test="persName/@ref">
                    <a href="../{data(substring-after(persName/@ref, 'https://www.manuscripta.se/'))}">
                        <xsl:value-of select="normalize-space(.)"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--<a href="{data(replace(persName/@ref, 'www', 'dev'))}">
                <xsl:choose>
                    <xsl:when test="persName">
                        <xsl:value-of select="persName" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </a>-->
        </div>
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
                <a href="/bibl/{data(substring-after(TEI/@xml:id, 'bibl-'))}.xml">
                    <xsl:text>https://www.manuscripta.se/bibl/</xsl:text>
                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'bibl-'))"/>
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

</xsl:stylesheet>