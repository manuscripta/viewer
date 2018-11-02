<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msg="urn:x-kosek:schemas:messages:1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="msg" version="3.0">

    <xsl:output method="html" version="5.0" indent="yes" encoding="utf-8"/>

    <xsl:template match="/">
        <main class="panel-group" id="msDescription" role="main">
            <xsl:apply-templates select="//revisionDesc"/>
            <section class="summary">
                <div class="page-header">
                    <h1>
                        <xsl:attribute name="id">
                            <xsl:value-of select="/TEI/@xml:id"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">
                            <!-- Create class attribute to enable or disable the image viewer in viewer.js -->
                            <xsl:choose>
                                <xsl:when test="//facsimile">
                                    <xsl:choose>
                                        <!-- Test if the number of images are greater than or equal to the number of textblock leaves * 2 -->
                                        <xsl:when test="count(//facsimile/surface) ge sum(//measure[@type = 'textblockLeaves']/@quantity) * 2">
                                            <xsl:text>digitized</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>digitized_partly</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>not_digitized</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:value-of select="//repository, //msDesc/msIdentifier/idno[@type = 'shelfmark']" separator=", "/>
                        <xsl:if test="//msIdentifier/altIdentifier/idno[@type = 'access-nr']">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="//msIdentifier/altIdentifier/idno[@type = 'access-nr']"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </h1>
                    <xsl:if test="//altIdentifier/idno[@type = 'formerShelfmark']">
                        <div>
                            <xsl:text>(</xsl:text>
                            <xsl:for-each select="//altIdentifier/idno[@type = 'formerShelfmark']">
                                <xsl:choose>
                                    <xsl:when test="position() != last()">
                                        <xsl:value-of select="."/>
                                        <xsl:text>; </xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:text>)</xsl:text>
                        </div>
                    </xsl:if>
                </div>
                <div>
                    <h2>
                        <xsl:value-of select="//msDesc/head"/>
                    </h2>
                    <p>
                        <xsl:if test="//origPlace">
                            <xsl:for-each select="//origPlace/placeName">
                                <xsl:value-of select="."/>
                                <xsl:text>, </xsl:text>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="//origin/@notBefore">
                            <xsl:value-of select="//origin/@notBefore"/>
                            <xsl:text>–</xsl:text>
                            <xsl:value-of select="//origin/@notAfter"/>
                        </xsl:if>
                        <xsl:if test="//origDate">
                            <xsl:apply-templates select="//origDate"/>
                        </xsl:if>
                    </p>
                    <p>
                        <xsl:for-each select="distinct-values(//msPart//supportDesc/@material)">
                            <xsl:if test=". = 'paper'">
                                paper
                            </xsl:if>
                            <xsl:if test=". = 'parchment'">
                                parchment
                            </xsl:if>
                        </xsl:for-each>
                    </p>
                    <p>
                        <xsl:if test="//measure[@type = 'leftFlyleaves' and @quantity ge '1']">
                            <xsl:number format="i" value="//measure[@type = 'leftFlyleaves']/@quantity"/>
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="sum(//measure[@type = 'textblockLeaves']/@quantity)"/>
                        <xsl:if test="//measure[@type = 'rightFlyleaves' and @quantity ge '1']">
                            <xsl:text>, </xsl:text>
                            <xsl:number format="i" value="//measure[@type = 'rightFlyleaves']/@quantity"/>
                            <xsl:text>'</xsl:text>
                        </xsl:if>
                        <xsl:text> ff.</xsl:text>
                    </p>
                    <xsl:if test="//support//dimensions[@type = 'leaf']/height">
                        <p>
                            <xsl:value-of select="distinct-values(//support//dimensions[@type = 'leaf']/height/@quantity)"/>
                            <xsl:text> × </xsl:text>
                            <xsl:value-of select="distinct-values(//support//dimensions[@type = 'leaf']/width/@quantity)"/>
                            <xsl:text> mm</xsl:text>
                        </p>
                    </xsl:if>
                    <!--<p>
                        <xsl:for-each select="//layoutDesc/layout/@writtenLines">                            
                            <xsl:if test="position() != last()">
                                <xsl:value-of select="concat(substring(., 1, 2), '–', substring(., 4, 5))" />
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:value-of select="concat(substring(., 1, 2), '–', substring(., 4, 5))" />
                                <xsl:text> ll.</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </p>-->
                    <xsl:if test="count(//msPart) gt 1">
                        <p>
                            <xsl:value-of select="count(//msPart)"/>
                            <xsl:text> </xsl:text>
                            units
                        </p>
                    </xsl:if>
                    <p>                       
                        <xsl:if test="//msContents/textLang/@mainLang = 'grc'">
                            Greek
                        </xsl:if>
                        <xsl:if test="//msContents/textLang/@mainLang = 'lat'">
                            Latin
                        </xsl:if>
                        <xsl:if test="//msContents/textLang/@mainLang = 'non-swe'">
                            Old Swedish
                        </xsl:if>
                        <xsl:if test="//msContents/textLang/@mainLang = 'sv'">
                            Swedish
                        </xsl:if>
                    </p>
                </div>
            </section>
            <section class="msContents panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <a data-toggle="collapse" href="#msContents" aria-expanded="false" aria-controls="msContents" class="collapsed">
                            Contents
                        </a>
                    </h3>
                </div>
                <div id="msContents" class="panel-collapse collapse" role="tabpanel" aria-labelledby="msContents" aria-expanded="false">
                    <div class="panel-body">
                        <xsl:for-each select="//msPart">
                            <xsl:if test="count(//msPart) gt 1">
                                <h4>
                                    Unit
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="msIdentifier/idno[@type = 'codicologicalUnit']/text()"/>
                                </h4>
                            </xsl:if>
                            <xsl:apply-templates select="msContents"/>
                        </xsl:for-each>
                    </div>
                </div>
            </section>
            <section class="physDesc panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <a data-toggle="collapse" href="#physDesc" aria-expanded="false" aria-controls="physDesc" class="collapsed">
                            Physical Description
                        </a>
                    </h3>
                </div>
                <div id="physDesc" class="panel-collapse collapse" role="tabpanel" aria-labelledby="physDesc" aria-expanded="false" style="height: 0px;">
                    <div class="panel-body">
                        <xsl:if test="//foliation[string-length(.) != 0]">
                            <div>
                                <h4>
                                    Foliation
                                </h4>
                                <xsl:for-each select="//foliation">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <p>
                                                <xsl:if test="count(//msPart) gt 1">
                                                    <h5>Unit<xsl:text> </xsl:text>
                                                        <xsl:number count="msPart" format="I"/>: </h5>
                                                </xsl:if>
                                                <xsl:apply-templates/>
                                            </p>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <p>
                                                <xsl:apply-templates/>
                                            </p>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                        <xsl:if test="//collation/formula[string-length(.) != 0] or //collation/catchwords or //collation/signatures">
                            <div>
                                <h4>
                                    Collation
                                </h4>
                                <div>
                                    <xsl:for-each select="//collation">
                                        <xsl:choose>
                                            <xsl:when test="ancestor::msPart">
                                                <p>
                                                    <xsl:if test="count(//msPart) gt 1">
                                                        <h5>Unit<xsl:text> </xsl:text>
                                                            <xsl:number count="msPart" format="I"/>: </h5>
                                                    </xsl:if>
                                                    <xsl:apply-templates/>
                                                </p>
                                                <!--<xsl:if test="position() != last()">
                                                <xsl:apply-templates select="physDesc//collation/formula" />
                                                <xsl:text>| </xsl:text>
                                            </xsl:if>
                                            <xsl:if test="position() = last()">
                                                <xsl:apply-templates select="physDesc//collation/formula" />
                                                <xsl:apply-templates select="//collation/p" />
                                            </xsl:if>-->
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <p>
                                                    <h5>Endleaves: </h5>
                                                    <xsl:apply-templates/>
                                                </p>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </div>
                            </div>
                        </xsl:if>
                        <xsl:if test="//supportDesc/condition">
                            <div>
                                <h4>
                                    Condition
                                </h4>
                                <xsl:for-each select="//supportDesc/condition">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <p>
                                                <xsl:if test="count(//msPart) gt 1">
                                                    <h5>Unit<xsl:text> </xsl:text>
                                                        <xsl:number count="msPart" format="I"/>: </h5>
                                                </xsl:if>
                                                <xsl:apply-templates/>
                                            </p>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <p>
                                                <h5>Endleaves: </h5>
                                                <xsl:apply-templates/>
                                            </p>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                        <!--<div>
                            <h4>Signatures: </h4>
                            <xsl:for-each select="//signatures">
                                <xsl:choose>
                                    <xsl:when test="//signatures[contains(., 'none')]">
                                        <xsl:choose>
                                            <xsl:when test="following-sibling::msPart[//signatures[not(contains(., 'none'))]]">
                                                <p>
                                                    <h5>Unit <xsl:number count="msPart" format="I" />: </h5> TEST </p>
                                            </xsl:when>
                                        </xsl:choose>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        <p>
                                            <h5>Unit <xsl:number count="msPart" format="I" />: </h5>
                                            <xsl:apply-templates select="." />
                                        </p>
                                    </xsl:otherwise>

                                </xsl:choose>
                            </xsl:for-each>
                        </div>
                        <div>
                            <h4>Catchwords: </h4>
                            <xsl:for-each select="//catchwords">
                                <p>
                                    <h5>Unit <xsl:number count="msPart" format="I" />: </h5>
                                    <xsl:apply-templates select="." />
                                </p>
                            </xsl:for-each>
                        </div>-->
                        <xsl:if test="//support[string-length(.) != 0]">
                            <div>
                                <h4>
                                    Support
                                </h4>
                                <xsl:for-each select="//support">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <xsl:choose>
                                                <xsl:when test="count(//msPart) gt 1">
                                                    <h5>
                                                        Unit
                                                        <xsl:text> </xsl:text>
                                                        <xsl:number count="msPart" format="I"/>
                                                    </h5>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <h5>
                                                        Bookblock
                                                    </h5>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:apply-templates/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <h5>
                                                Endleaves
                                            </h5>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                        <xsl:if test="//handDesc[string-length(.) != 0]">
                            <div>
                                <h4>
                                    Script
                                </h4>
                                <xsl:for-each select="//handDesc">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <p>
                                                <xsl:if test="count(//msPart) gt 1">
                                                    <h5>Unit<xsl:text> </xsl:text>
                                                        <xsl:number count="msPart" format="I"/>: </h5>
                                                </xsl:if>
                                                <xsl:apply-templates select="handNote"/>
                                            </p>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <p>
                                                <h5>Bookblock: </h5>
                                                <xsl:apply-templates select="handNote"/>
                                            </p>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                        <xsl:if test="//decoDesc[string-length(.) != 0]">
                            <div>
                                <h4>
                                    Decorations
                                </h4>
                                <xsl:for-each select="//decoDesc">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <p>
                                                <xsl:if test="count(//msPart) gt 1">
                                                    <h5>Unit<xsl:text> </xsl:text>
                                                        <xsl:number count="msPart" format="I"/>: </h5>
                                                </xsl:if>
                                                <xsl:apply-templates select="decoNote | p"/>
                                            </p>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <p>
                                                <h5>Bookblock: </h5>
                                                <xsl:apply-templates select="decoNote | p"/>
                                            </p>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                        <xsl:if test="//additions[string-length(.) != 0]">
                            <div>
                                <h4>
                                    Additions
                                </h4>
                                <xsl:for-each select="//additions">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <xsl:if test="count(//msPart) gt 1">
                                                <h5>
                                                    Unit
                                                    <xsl:text> </xsl:text>
                                                    <xsl:number count="msPart" format="I"/>
                                                </h5>
                                            </xsl:if>
                                            <xsl:apply-templates/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <h5>
                                                Endleaves
                                            </h5>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                        <xsl:if test="//layoutDesc[string-length(.) != 0]">
                            <div>
                                <h4>
                                    Layout
                                </h4>
                                <xsl:for-each select="//layoutDesc">
                                    <xsl:apply-templates/>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                        <xsl:if test="//bindingDesc[string-length(.) != 0]">
                            <div>
                                <h4>
                                    Binding
                                </h4>
                                <xsl:apply-templates select="//bindingDesc"/>
                            </div>
                        </xsl:if>
                    </div>
                </div>
            </section>
            <section class="history panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <a data-toggle="collapse" href="#history" aria-expanded="false" aria-controls="history" class="collapsed">
                            History
                        </a>
                    </h3>
                </div>
                <div id="history" class="panel-collapse collapse" role="tabpanel" aria-labelledby="history" aria-expanded="false" style="height: 0px;">
                    <div class="panel-body">
                        <xsl:call-template name="history"/>
                    </div>
                </div>
            </section>
            <section class="additional panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <a data-toggle="collapse" href="#additional" aria-expanded="false" aria-controls="additional" class="collapsed">
                            Bibliography
                        </a>
                    </h3>
                </div>
                <div id="additional" class="panel-collapse collapse" role="tabpanel" aria-labelledby="additional" aria-expanded="false" style="height: 0px;">
                    <div class="panel-body">
                        <div class="bibliography">
                            <xsl:apply-templates select="//additional"/>
                        </div>
                        <div class="surrogates">
                            <xsl:apply-templates select="//surrogates"/>
                        </div>
                    </div>
                </div>
            </section>
            <section class="additional panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <a data-toggle="collapse" href="#metadata" aria-expanded="false" aria-controls="metadata" class="collapsed">
                            Metadata
                        </a>
                    </h3>
                </div>
                <div id="metadata" class="panel-collapse collapse" role="tabpanel" aria-labelledby="metadata" aria-expanded="false" style="height: 0px;">
                    <div class="panel-body">
                        <div>
                            <h4>
                                Statement of Responsibility
                            </h4>
                            <div>
                                <xsl:if test="//respStmt/resp[@key = 'cataloguer']">
                                    Cataloguing
                                    <xsl:text>: </xsl:text>
                                    <xsl:for-each select="//respStmt[resp[@key = 'cataloguer']]">
                                        <xsl:apply-templates select="persName"/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </div>
                            <div>
                                <xsl:if test="//respStmt/resp[@key = 'encoder']">
                                    Encoding
                                    <xsl:text>: </xsl:text>
                                    <xsl:for-each select="//respStmt[resp[@key = 'encoder']]">
                                        <xsl:apply-templates select="persName"/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                            </div>
                            <div>
                                Sponsor
                                <xsl:text>: </xsl:text>
                                <xsl:for-each select="//sponsor">
                                    <xsl:apply-templates select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </div>
                            <div>
                                Funder
                                <xsl:text>: </xsl:text>
                                <xsl:for-each select="//funder">
                                    <xsl:apply-templates select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </div>
                        </div>
                        <xsl:if test="//idno[@type = 'id'][@subtype = 'Diktyon'] or //idno[@type = 'id'][@subtype = 'Libris'] or //idno[@type = 'id'][@subtype = 'Alvin']">
                            <div>
                                <h4>
                                    External Identifiers
                                </h4>
                                <xsl:if test="//idno[@type = 'id'][@subtype = 'Diktyon']">
                                    <div>
                                        Diktyon ID
                                        <xsl:text>: </xsl:text>
                                        <a href="http://pinakes.irht.cnrs.fr/notices/cote/{data(//idno[@type = 'id'][@subtype='Diktyon'])}/">
                                            <xsl:value-of select="//idno[@type = 'id'][@subtype = 'Diktyon']"/>
                                        </a>
                                    </div>
                                </xsl:if>
                                <xsl:if test="//idno[@type = 'id'][@subtype = 'Libris']">
                                    <div>
                                        Libris ID
                                        <xsl:text>: </xsl:text>
                                        <a href="http://libris.kb.se/bib/{data(//idno[@type = 'id'][@subtype='Libris'])}">
                                            <xsl:text>http://libris.kb.se/bib/</xsl:text>
                                            <xsl:value-of select="//idno[@type = 'id'][@subtype = 'Libris']"/>
                                        </a>
                                    </div>
                                </xsl:if>
                                <xsl:if test="//idno[@type = 'id'][@subtype = 'Alvin']">
                                    <div>
                                        Alvin ID
                                        <xsl:text>: </xsl:text>
                                        <a href="https://www.alvin-portal.org/alvin/view.jsf?pid={data(//idno[@type = 'id'][@subtype='Alvin'])}">
                                            <xsl:value-of select="//idno[@type = 'id'][@subtype = 'Alvin']"/>
                                        </a>
                                    </div>
                                </xsl:if>
                            </div>
                        </xsl:if>
                        <div>
                            <h4>
                                Internal Identifiers
                            </h4>
                            <div>
                                Permalink
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="//idno[@subtype = 'Manuscripta']"/>
                            </div>
                            <div>
                                XML
                                <xsl:text>: </xsl:text>
                                <a href="/xml/{data(substring-after(TEI/@xml:id, 'ms-'))}">
                                    <xsl:text>https://www.manuscripta.se/xml/</xsl:text>
                                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'ms-'))"/>
                                </a>
                            </div>
                        </div>
                        <xsl:if test="//facsimile">
                            <div>
                                IIIF Manifest
                                <xsl:text>: </xsl:text>
                                <a href="/iiif/{data(substring-after(TEI/@xml:id, 'ms-'))}/manifest.json">
                                    <xsl:text>https://www.manuscripta.se/iiif/</xsl:text>
                                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'ms-'))"/>
                                    <xsl:text>/manifest.json</xsl:text>
                                </a>
                            </div>
                        </xsl:if>
                        <div>
                            <h4>
                                License
                            </h4>
                            <div xml:space="preserve">
                                Description
                                <xsl:text>: </xsl:text>
                                <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"> CC BY 4.0</a>
                            </div>
                            <xsl:if test="//facsimile">
                                <div>
                                    Images
                                    <xsl:text>: </xsl:text>
                                    <a href="https://creativecommons.org/publicdomain/zero/1.0/">Public Domain</a>
                                </div>
                            </xsl:if>
                        </div>
                        <div class="lastRevision">
                            <xsl:apply-templates select="//change"/>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </xsl:template>

    <!-- TEI -->
    <xsl:template match="acquisition">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="add">
        <xsl:value-of select="."/>
        <xsl:text> added </xsl:text>
        <xsl:value-of select="@place"/>
    </xsl:template>
    <xsl:template match="additional">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="additions">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="addName">
        <span class="name">
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    <xsl:template match="altIdentifier">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="author">
        <span class="author">
            <xsl:choose>
                <xsl:when test="ancestor::body | parent::msItem">
                    <xsl:apply-templates select="persName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="persName" mode="abbreviated-name"/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
        <!--<xsl:choose>
            <xsl:when test="parent::msItem">
                <span class="small-caps">
                    <xsl:apply-templates />
                </span>
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
                <!-\-<xsl:for-each select=".">
                    <xsl:if test="position() != last()">
                        <span class="bibl_author">
                            <xsl:for-each select="persName/forename">
                                <xsl:if test="position() != last()">
                                    <xsl:value-of select="substring(., 1, 1)" />
                                    <xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="position() = last()">
                                    <xsl:value-of select="substring(., 1, 1)" />
                                    <xsl:text>. </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:apply-templates select="persName/surname" />
                            <xsl:text>, </xsl:text>
                        </span>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <span class="bibl_author">
                            <xsl:for-each select="persName/forename">
                                <xsl:if test="position() != last()">
                                    <xsl:value-of select="substring(., 1, 1)" />
                                    <xsl:text>. </xsl:text>
                                </xsl:if>
                                <xsl:if test="position() = last()">
                                    <xsl:value-of select="substring(., 1, 1)" />
                                    <xsl:text>. </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:apply-templates select="persName/surname" />
                        </span>
                    </xsl:if>
                    </xsl:for-each>-\->
            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>
    <!-- authority -->
    <!-- availability -->
    <xsl:template match="bibl">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <div class="editions">
                    <span class="head">Edition: </span>
                    <xsl:apply-templates select="title"/>
                    <xsl:text> </xsl:text>
                    <xsl:choose>
                        <xsl:when test="exists(biblScope)">
                            <xsl:apply-templates select="biblScope"/>
                        </xsl:when>
                        <xsl:when test="exists(biblScope) and following-sibling::citedRange">
                            <xsl:apply-templates select="biblScope"/>
                            <xsl:text> [</xsl:text>
                            <xsl:for-each select="citedRange">
                                <xsl:if test="position() != last()">
                                    <xsl:apply-templates select="."/>
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                                <xsl:if test="position() = last()">
                                    <xsl:apply-templates select="."/>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:text>]</xsl:text>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="citedRange">
                                <xsl:if test="position() != last()">
                                    <xsl:apply-templates select="."/>
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                                <xsl:if test="position() = last()">
                                    <xsl:apply-templates select="."/>
                                </xsl:if>
                                <xsl:apply-templates/>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>.</xsl:text>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="title"/>
                <xsl:text> </xsl:text>
                <xsl:choose>
                    <xsl:when test="exists(biblScope)">
                        <xsl:apply-templates select="biblScope"/>
                    </xsl:when>
                    <xsl:when test="exists(biblScope) and following-sibling::citedRange">
                        <xsl:apply-templates select="biblScope"/>
                        <xsl:text> [</xsl:text>
                        <xsl:for-each select="citedRange">
                            <xsl:if test="position() != last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:apply-templates select="."/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>]</xsl:text>
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="citedRange">
                            <xsl:if test="position() != last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:apply-templates select="."/>
                            </xsl:if>
                            <xsl:apply-templates/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--<xsl:template name="bibl">
        <div class="biblItem">
            <xsl:apply-templates select="title" />
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="exists(title[@level='a']) and exists(title[@level='m'])">
                    <xsl:if test="exists(author)">
                        <xsl:for-each select="author[not(@role='origAuth')]">
                            <xsl:if test="position() != last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, and </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:apply-templates select="title[@level='a']"/>
                    <xsl:text>, in </xsl:text>
                    <xsl:apply-templates select="title[@level='m']"/>
                    <xsl:text>, </xsl:text>
                    <xsl:for-each select="editor">
                        <xsl:if test="position() != last()">
                            <xsl:apply-templates select="."/>
                            <xsl:text>, and </xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:apply-templates select="."/>
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text> (ed.) </xsl:text>
                    <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="pubPlace"/>
                    <xsl:text/>
                    <xsl:apply-templates select="date"/>
                    <xsl:text>) </xsl:text>
                </xsl:when>
                <xsl:when test="exists(title[@level='a']) and exists(title[@level='j'])">
                    <xsl:if test="exists(author)">
                        <xsl:for-each select="author[not(@role='origAuth')]">
                            <xsl:if test="position() != last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, and </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:apply-templates select="title[@level='a']"/>
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="title[@level='j']"/>
                    <xsl:text/>
                    <xsl:apply-templates select="biblScope[@unit='volume']"/>
                    <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="date"/>
                    <xsl:text>) </xsl:text>
                </xsl:when>
                <xsl:when test="exists(title[@level='m'][@type='short'])">
                    <xsl:apply-templates select="title[@type='short']"/>
                    <xsl:text/>
                </xsl:when>
                <xsl:when test="exists(title[@level='u'])">
                    <xsl:if test="exists(author)">
                        <xsl:for-each select="author[not(@role='origAuth')]">
                            <xsl:if test="position() != last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, and </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:apply-templates select="title[@level='u']"/>
                    <xsl:if test="exists(date)">
                        <xsl:text> (</xsl:text>
                        <xsl:apply-templates select="date"/>
                        <xsl:text>) </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="exists(author)">
                        <xsl:for-each select="author[not(@role='origAuth')]">
                            <xsl:if test="position() != last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, and </xsl:text>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:apply-templates select="."/>
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:apply-templates select="title[@level='m']"/>
                    <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="pubPlace"/>
                    <xsl:text/>
                    <xsl:apply-templates select="date"/>
                    <xsl:text>) </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="exists(biblScope)">
                    <xsl:apply-templates select="biblScope" />
                </xsl:when>
                <xsl:when test="exists(biblScope) and following-sibling::citedRange">
                    <xsl:apply-templates select="biblScope" />
                    <xsl:text> [</xsl:text>
                    <xsl:for-each select="citedRange">
                        <xsl:if test="position() != last()">
                            <xsl:apply-templates select="." />
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:apply-templates select="." />
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>]</xsl:text>
                    <xsl:apply-templates />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="citedRange">
                        <xsl:if test="position() != last()">
                            <xsl:apply-templates select="." />
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:apply-templates select="." />
                        </xsl:if>
                        <xsl:apply-templates />
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>.</xsl:text>
        </div>
    </xsl:template>-->
    <!--<xsl:template match="bibl" priority="0">
        <xsl:choose>
            <xsl:when test="@type='article-journal'">
                <xsl:text> ARTICLE </xsl:text>
                <xsl:for-each select="author">
                    <xsl:if test="position() != last()">
                        <xsl:apply-templates select="." />
                        <xsl:text>, and </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:apply-templates select="." />
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:apply-templates select="title[@level='a']" />
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="title[@level='j']" />
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="biblScope[@unit='volume']" />
                <xsl:text> (</xsl:text>
                <xsl:apply-templates select="date" />
                <xsl:text>) </xsl:text>
                <xsl:apply-templates select="biblScope[@unit='page']" />
                <xsl:if test="exists(citedRange)">
                    <xsl:text> [</xsl:text>
                    <xsl:for-each select="citedRange">
                        <xsl:if test="position() != last()">
                            <xsl:apply-templates select="citedRange" />
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:if test="position() = last()">
                            <xsl:apply-templates select="citedRange" />
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>]</xsl:text>
                    <xsl:apply-templates />
                </xsl:if>
            </xsl:when>
            <xsl:when test="@type='book'">
                <xsl:text> BOOK </xsl:text>
                <xsl:for-each select="author">
                    <xsl:if test="position() != last()">
                        <xsl:apply-templates select="." />
                        <xsl:text>, and </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:apply-templates select="." />
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:apply-templates select="title[@level='m']" />
                <xsl:if test="exists(pubPlace)">
                    <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="pubPlace" />
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="date" />
                    <xsl:text>) </xsl:text>
                </xsl:if>
                <xsl:if test="exists(biblScope)">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="biblScope[@unit='page']" />
                </xsl:if>
                <xsl:if test="exists(citedRange)">
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::biblScope">
                            <xsl:text> [</xsl:text>
                            <xsl:apply-templates select="citedRange" />
                            <xsl:text>].</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select="citedRange" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:when test="@type='edition'">
                <div class="ms-item-edition">
                    <span class="head">Edition: </span>
                    <xsl:text> EDITION </xsl:text>
                    <xsl:if test="exists(editor)">
                        <xsl:apply-templates select="editor" />
                        <xsl:text> (ed.) </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="title" />
                    <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="pubPlace" />
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="date" />
                    <xsl:text>) </xsl:text>
                    <xsl:apply-templates select="citedRange" />
                </div>
            </xsl:when>
            <!-\-<xsl:when test="child::title[@type='short']">
                <xsl:apply-templates select="title[@type='short']" />
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="biblScope" />
                <xsl:apply-templates select="citedRange" />
            </xsl:when>-\->
            <!-\-<xsl:when test="ancestor::additional or ancestor::body">
                <span class="biblItem">
                    <xsl:apply-templates />
                </span>
            </xsl:when>-\->

            <!-\-<xsl:when test="child::title[@type='short']">
                <xsl:apply-templates select="title[@type='short']" />
                <xsl:text> </xsl:text>
                <!-\\-<xsl:apply-templates select="biblScope" />-\\->
                <xsl:apply-templates select="citedRange" />
            </xsl:when>-\->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="exists(author)">
                        <xsl:text> NO-TYPE </xsl:text>
                        <xsl:apply-templates select="author" />
                        <xsl:text> (</xsl:text>
                        <xsl:apply-templates select="date" />
                        <xsl:text>) </xsl:text>
                        <xsl:apply-templates select="title" />
                        <xsl:text>, edited by  </xsl:text>
                        <xsl:apply-templates select="editor" />
                        <xsl:text>. </xsl:text>
                        <xsl:apply-templates select="pubPlace" />
                        <xsl:text>, </xsl:text>
                        <xsl:apply-templates select="citedRange" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> NO-TYPE </xsl:text>
                        <xsl:apply-templates select="title" />
                        <xsl:text> (</xsl:text>
                        <xsl:apply-templates select="date" />
                        <xsl:text>) </xsl:text>
                        <xsl:text>, edited by  </xsl:text>
                        <xsl:apply-templates select="editor" />
                        <xsl:text>. </xsl:text>
                        <xsl:apply-templates select="pubPlace" />
                        <xsl:text>, </xsl:text>
                        <xsl:apply-templates select="citedRange" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    <!--<xsl:template match="biblScope|citedRange">
        <xsl:choose>
            <xsl:when test="@from = @to">
                <xsl:value-of select="@from" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@from" />–<xsl:value-of select="@to" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    <xsl:template match="citedRange">
        <xsl:choose>
            <xsl:when test="@unit = 'volume'">
                <xsl:choose>
                    <xsl:when test="following-sibling::citedRange[@unit = 'volume']">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                vol.
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@from"/>
                                <xsl:text>, </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                vols.
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                                <xsl:text>, </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                vol.
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@from"/>
                            </xsl:when>
                            <xsl:otherwise>
                                vols.
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit = 'page'">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        p.
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        pp.
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit = 'column'">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        col.
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        cols.
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit = 'footnote'">
                <xsl:text>, n. </xsl:text>
                <xsl:value-of select="@from"/>
            </xsl:when>
            <xsl:when test="@unit = 'number'">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        no.
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        nos.
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
                <!--<xsl:apply-templates />-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="binding">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="bindingDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <!--  Body  -->
    <xsl:template match="catchwords">
        <xsl:if test="string-length(.) != 0">
            <div>
                <h5>Catchwords: </h5>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="change">
        <xsl:if test="position() = 1">
            Last revision
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@when"/>
        </xsl:if>
    </xsl:template>
    <!--  CitedRange, see biblScope  -->
    <xsl:template match="collation">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="colophon">
        <div class="colophon">
            <span class="head">Colophon: </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="condition">
        <div class="condition">
            <span class="head">Condition: </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!--  Country  -->
    <xsl:template match="date | origDate">
        <span class="date">
            <xsl:choose>
                <xsl:when test="exists(text())">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="@from">
                        <xsl:value-of select="@from"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="@to"/>
                    </xsl:if>
                    <xsl:if test="@notBefore and @notAfter">
                        <xsl:value-of select="@notBefore"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="@notAfter"/>
                    </xsl:if>
                    <xsl:if test="@notBefore and not(@notAfter)">
                        <xsl:value-of select="@notBefore"/>
                    </xsl:if>
                    <xsl:if test="@notAfter and not(@notBefore)">
                        <xsl:value-of select="@notAfter"/>
                    </xsl:if>
                    <xsl:if test="@when">
                        <xsl:value-of select="@when"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    <xsl:template match="decoDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="decoNote">
        <div>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="del">
        <xsl:value-of select="."/>
        <xsl:text> deleted, </xsl:text>
    </xsl:template>
    <xsl:template match="depth">
        <xsl:if test="@quantity">
            <xsl:value-of select="@quantity"/>
        </xsl:if>
        <xsl:if test="@min">
            <xsl:value-of select="@min"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@max"/>
        </xsl:if>
        <xsl:text> mm</xsl:text>
    </xsl:template>
    <!--  desc  -->
    <xsl:template match="dimensions">
        <xsl:if test="@type = 'written'">
            <em>Written area: </em>
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:if test="@type = 'binding'">
            <em>Binding dimensions: </em>
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:if test="@type = 'watermark'">
            <em>Watermark dimensions: </em>
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:if test="@type = 'chainLines'">
            <em>Chainlines: </em>
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:if test="@type = 'leaf'">
            <xsl:text>(</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    <!--  div -->
    <xsl:template match="edition">
        <xsl:value-of select="@n"/>
        <xsl:text>. ed.</xsl:text>
    </xsl:template>
    <xsl:template match="editor">
        <xsl:apply-templates select="persName" mode="abbreviated-name"/>
    </xsl:template>
    <xsl:template match="ex">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    <xsl:template match="explicit">
        <div class="explicit">
            <span class="head">Explicit: </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!--  extent  -->
    <!--  facsimile  -->
    <!--  fileDesc  -->
    <xsl:template match="filiation">
        <div class="note">
            <xsl:if test="@type = 'protograph'">
                <span class="head">Protograph: </span>
                <xsl:apply-templates/>
            </xsl:if>
            <xsl:if test="@type = 'apograph'">
                <span class="head">Apograph: </span>
                <xsl:apply-templates/>
            </xsl:if>
            <xsl:if test="@type = 'siglum'">
                <span class="head">Sigla: </span>
                <xsl:apply-templates/>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="finalRubric">
        <div class="final-rubric">
            <span class="head">Final rubric: </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="foliation">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="foreign">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="forename">
        <span class="name">
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    <xsl:template match="forename" mode="abbreviated-name">
        <xsl:value-of select="substring(., 1, 1)"/>
        <xsl:text>.</xsl:text>
    </xsl:template>
    <xsl:template match="formula">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="funder">
        <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="gap">
        <!--FIX-->
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="genName">
        <span class="name">
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    <!--  graphic  -->
    <!--  handDesc  -->
    <xsl:template match="handNote">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="head">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="height">
        <xsl:if test="@quantity">
            <xsl:value-of select="@quantity"/>
            <xsl:text> × </xsl:text>
        </xsl:if>
        <xsl:if test="@min">
            <xsl:value-of select="@min"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@max"/>
            <xsl:text> × </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="hi">
        <xsl:if test="@rend = 'super'">
            <sup>
                <xsl:apply-templates/>
            </sup>
        </xsl:if>
        <xsl:if test="@rend = 'sub'">
            <sub>
                <xsl:apply-templates/>
            </sub>
        </xsl:if>
    </xsl:template>
    <xsl:template name="history" match="history">
        <div class="origin">
            <h4>
                Origin
            </h4>
            <p>
                <xsl:apply-templates select="//msDesc/history/origin"/>
            </p>
            <xsl:for-each select="//msPart/history/origin">
                <p>
                    <h5>Unit<xsl:text> </xsl:text>
                        <xsl:number count="msPart" format="I"/>: </h5>
                    <xsl:apply-templates select="."/>
                </p>
            </xsl:for-each>
        </div>
        <div class="provenance">
            <h4>
                Provenance
            </h4>
            <xsl:for-each select="//provenance">
                <p>
                    <xsl:apply-templates select="."/>
                </p>
            </xsl:for-each>
        </div>
        <!--<div class="formerShelfmarks">
            <xsl:apply-templates select="//idno" />
        </div>-->
        <div class="acquisition">
            <h4>
                Acquisition
            </h4>
            <xsl:apply-templates select="//acquisition"/>
        </div>
    </xsl:template>
    <xsl:template match="idno">
        <xsl:choose>
            <!--<xsl:when test="@type = 'formerShelfmark'">
                <h4><msg:Former_shelfmarks />: </h4>
                <xsl:for-each select="idno">
                    <xsl:apply-templates />
                </xsl:for-each>
            </xsl:when>-->
            <xsl:when test="@type = 'msRef'">
                <xsl:apply-templates/>
            </xsl:when>
            <!--<xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>-->
        </xsl:choose>
    </xsl:template>
    <xsl:template match="incipit">
        <div class="incipit">
            <span class="head">Incipit: </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!-- institution -->
    <!-- item -->
    <!-- layout -->
    <xsl:template match="layoutDesc">
        <xsl:for-each select="layout">
            <p>
                <xsl:apply-templates select="locus | locusGrp"/>
                <!-- Only show columns when greater than 1 -->
                <xsl:if test="@columns[. gt '1']">
                    <xsl:value-of select="@columns"/>
                    <xsl:text> </xsl:text>
                    columns
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="@ruledLines">
                    <xsl:value-of select="concat(substring(@ruledLines, 1, 2), '–', substring(@ruledLines, 4, 5))"/>
                    <xsl:text> </xsl:text>
                    ruled lines
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="@writtenLines">
                    <xsl:choose>
                        <!-- Check for min and max values -->
                        <xsl:when test="substring(@writtenLines, 4, 5)">
                            <xsl:value-of select="concat(substring(@writtenLines, 1, 2), '–', substring(@writtenLines, 4, 5))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(@writtenLines, 1, 2)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> </xsl:text>
                    written lines
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="dimensions"/>
                <xsl:apply-templates select="note"/>
            </p>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="lb">
        <xsl:text> | </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <!-- licence -->
    <xsl:template match="list">
        <xsl:choose>
            <xsl:when test="@type = 'toc'">
                <xsl:for-each select="item">
                    <xsl:if test="position() != last()">
                        <xsl:apply-templates select="locus | locusGrp"/>
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:apply-templates select="locus | locusGrp"/>
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="listBibl">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <div class="editions">
                    <span class="head">Editions: </span>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="parent::additional">
                <ul>
                    <xsl:for-each select="bibl">
                        <li>
                            <xsl:apply-templates/>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--<xsl:template match="listBibl">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <div class="msItem_listBibl">
                    <span class="head">Editions: </span>
                    <xsl:for-each select="bibl">
                        <p>
                            <xsl:choose>
                                <xsl:when test="@type='edition'">
                                    <xsl:apply-templates select="author" />
                                    <!-\-<xsl:value-of select="normalize-space(author)" />-\->
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:apply-templates select="pubPlace" />
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="date" />
                                    <xsl:text>) </xsl:text>
                                    <xsl:apply-templates select="citedRange" />
                                </xsl:when>
                                <xsl:when test="child::title[@type='short']">
                                    <xsl:apply-templates select="title[@type='short']" />
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="biblScope" />
                                    <xsl:apply-templates select="citedRange" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="exists(author)">
                                            <xsl:apply-templates select="author" />
                                            <xsl:text> (</xsl:text>
                                            <xsl:apply-templates select="date" />
                                            <xsl:text>) </xsl:text>
                                            <xsl:apply-templates select="title" />
                                            <xsl:text>, edited by  </xsl:text>
                                            <xsl:apply-templates select="editor" />
                                            <xsl:text>. </xsl:text>
                                            <xsl:apply-templates select="pubPlace" />
                                            <xsl:text>, </xsl:text>
                                            <xsl:apply-templates select="citedRange" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="title" />
                                            <xsl:text> (</xsl:text>
                                            <xsl:apply-templates select="date" />
                                            <xsl:text>) </xsl:text>
                                            <xsl:text>, edited by  </xsl:text>
                                            <xsl:apply-templates select="editor" />
                                            <xsl:text>. </xsl:text>
                                            <xsl:apply-templates select="pubPlace" />
                                            <xsl:text>, </xsl:text>
                                            <xsl:apply-templates select="citedRange" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <!-\-<xsl:apply-templates select="author" />
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:apply-templates select="pubPlace" />
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="date" />
                                    <xsl:text>) </xsl:text>
                                    <xsl:apply-templates select="biblScope" />
                                    <xsl:apply-templates select="citedRange" />-\->
                                </xsl:otherwise>
                            </xsl:choose>
                        </p>
                    </xsl:for-each>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <span class="additional_listBibl">
                    <xsl:for-each select="element(bibl)">
                        <span class="additional_listBibl_item">
                            <xsl:choose>
                                <xsl:when test="title[@level='a']">
                                    <xsl:apply-templates select="author|editor" />
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title[@level='a']" />
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title[@level='j']" />
                                    <xsl:text> </xsl:text>
                                    <xsl:apply-templates select="biblScope[@unit='volume']" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:apply-templates select="date" />
                                    <xsl:text>) </xsl:text>
                                    <xsl:if test="biblScope">
                                        <xsl:apply-templates select="biblScope[@unit='page']" />
                                    </xsl:if>
                                    <xsl:if test="citedRange">
                                        <xsl:text> [</xsl:text>
                                        <xsl:apply-templates select="citedRange" />
                                        <xsl:text>].</xsl:text>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="author" />
                                    <xsl:text>, </xsl:text>
                                    <xsl:apply-templates select="title" />
                                    <xsl:text> (</xsl:text>
                                    <xsl:apply-templates select="pubPlace" />
                                    <xsl:if test="exists(pubPlace)">
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:apply-templates select="date" />
                                    <xsl:text>) </xsl:text>
                                    <xsl:if test="biblScope">
                                        <xsl:apply-templates select="biblScope[@unit='page']" />
                                    </xsl:if>
                                    <xsl:if test="citedRange">
                                        <xsl:text> [</xsl:text>
                                        <xsl:apply-templates select="citedRange" />
                                        <xsl:text>].</xsl:text>
                                    </xsl:if>
                                    <xsl:text>.</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                    </xsl:for-each>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    <!--<xsl:template match="locus">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <xsl:if test="@scheme='folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(f. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(ff. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme='pages'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(p. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(pp. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@scheme='folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">f. 
                                <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">ff. <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a><xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme='pages'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">p. 
                                <a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a></span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">pp. <xsl:value-of select="@from" />–<xsl:value-of select="@to" /><xsl:text> </xsl:text></span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    <xsl:template match="locus">
        <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
        <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
        <xsl:variable name="locusFrom" select="                 if (@from[contains(., ':')]) then                     substring-before(@from, ':')                 else                     if (@from[ends-with(., 'a')]) then                         substring-before(@from, 'a')                     else                         if (@from[ends-with(., 'b')]) then                             substring-before(@from, 'b')                         else                             if (@scheme = 'folios' and @from[not(contains(., 'r') or contains(., 'v'))]) then                                 (concat(@from, 'r'))                             else                                 data(@from)"/>
        <xsl:variable name="locusTo" select="                 if (@to[contains(., ':')]) then                     substring-before(@to, ':')                 else                     if (@to[ends-with(., 'a')]) then                         substring-before(@to, 'a')                     else                         if (@to[ends-with(., 'b')]) then                             substring-before(@to, 'b')                         else                             if (@scheme = 'folios' and @to[not(contains(., 'r') or contains(., 'v'))]) then                                 (concat(@to, 'r'))                             else                                 data(@to)"/>
        <!--<xsl:variable name="locusFromURL" select="//surface[@xml:id=concat(//TEI/@xml:id,'_',$locusFrom)]/graphic/@url"/>-->
        <xsl:variable name="locusFromIndex" select="count(//surface[@xml:id = concat(//TEI/@xml:id, '_', $locusFrom)]/preceding-sibling::*)"/>
        <!--<xsl:variable name="locusToURL" select="//surface[@xml:id=concat(//TEI/@xml:id,'_',$locusTo)]/graphic/@url"/>-->
        <xsl:variable name="locusToIndex" select="count(//surface[@xml:id = concat(//TEI/@xml:id, '_', $locusTo)]/preceding-sibling::*)"/>
        <xsl:choose>
            <xsl:when test="parent::msItem or ancestor::additions or ancestor::decoDesc">
                <xsl:if test="@scheme = 'folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <!--<span class="locus">(f. <a onclick="$('#diva-wrapper').data('diva').gotoPageByName('{$locusFromURL}')" href="#">-->
                            <span class="locus">(f. <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>)<xsl:text/>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(ff. <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                    <xsl:value-of select="@to"/>
                                </a>)<xsl:text/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme = 'pages'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(p.
                                <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>)<xsl:text/>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(pp.
                                <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                    <xsl:value-of select="@to"/>
                                </a>)<xsl:text/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme = 'other'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">(<a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>)<xsl:text/>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(<a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                    <xsl:value-of select="@to"/>
                                </a>)<xsl:text/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="@scheme = 'folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">f. <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">ff. <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                    <xsl:value-of select="@to"/>
                                </a>
                                <xsl:text/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme = 'pages'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">p. <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">pp. <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                    <xsl:value-of select="@to"/>
                                </a>
                                <xsl:text/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                <xsl:if test="@scheme = 'other'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
                            <span class="locus">
                                <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">
                                <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a> – <a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                    <xsl:value-of select="@to"/>
                                </a>
                                <xsl:text/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="locusGrp">
        <xsl:choose>
            <xsl:when test="parent::watermark">
                <xsl:if test="locus/@scheme = 'folios'">
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme = 'pages'">
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <!--<xsl:for-each select="locusGrp">-->
                <xsl:for-each select="locus">
                    <xsl:variable name="locusFrom" select="                             if (@from[contains(., ':')]) then                                 substring-before(@from, ':')                             else                                 if (@from[ends-with(., 'a')]) then                                     substring-before(@from, 'a')                                 else                                     if (@from[ends-with(., 'b')]) then                                         substring-before(@from, 'b')                                     else                                         if (@scheme = 'folios' and @from[not(contains(., 'r') or contains(., 'v'))]) then                                             (concat(@from, 'r'))                                         else                                             data(@from)"/>
                    <xsl:variable name="locusTo" select="                             if (@to[contains(., ':')]) then                                 substring-before(@to, ':')                             else                                 if (@to[ends-with(., 'a')]) then                                     substring-before(@to, 'a')                                 else                                     if (@to[ends-with(., 'b')]) then                                         substring-before(@to, 'b')                                     else                                         if (@scheme = 'folios' and @to[not(contains(., 'r') or contains(., 'v'))]) then                                             (concat(@to, 'r'))                                         else                                             data(@to)"/>
                    <xsl:variable name="locusFromIndex" select="count(//surface[@xml:id = concat(//TEI/@xml:id, '_', $locusFrom)]/preceding-sibling::*)"/>
                    <xsl:variable name="locusToIndex" select="count(//surface[@xml:id = concat(//TEI/@xml:id, '_', $locusTo)]/preceding-sibling::*)"/>
                    <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>/</span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                        <xsl:value-of select="@to"/>
                                    </a>/</span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                        <xsl:value-of select="@to"/>
                                    </a>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                <!--</xsl:for-each>-->
                <xsl:if test="position() != last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="position() = last()">
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <!--<xsl:apply-templates />-->
            </xsl:when>
            <xsl:when test="parent::msItem or ancestor::additions">
                <xsl:if test="locus/@scheme = 'folios'">
                    <xsl:text>(ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme = 'pages'">
                    <xsl:text>(pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:variable name="locusFrom" select="                             if (@from[contains(., ':')]) then                                 substring-before(@from, ':')                             else                                 if (@scheme = 'folios' and @from[not(contains(., 'r') or contains(., 'v'))]) then                                     (concat(@from, 'r'))                                 else                                     data(@from)"/>
                    <xsl:variable name="locusTo" select="                             if (@to[contains(., ':')]) then                                 substring-before(@to, ':')                             else                                 if (@scheme = 'folios' and @to[not(contains(., 'r') or contains(., 'v'))]) then                                     (concat(@to, 'r'))                                 else                                     data(@to)"/>
                    <xsl:variable name="locusFromIndex" select="count(//surface[@xml:id = concat(//TEI/@xml:id, '_', $locusFrom)]/preceding-sibling::*)"/>
                    <xsl:variable name="locusToIndex" select="count(//surface[@xml:id = concat(//TEI/@xml:id, '_', $locusTo)]/preceding-sibling::*)"/>
                    <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>, </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                        <xsl:value-of select="@to"/>
                                    </a>, </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <span class="locus">
                            <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                <xsl:value-of select="@from"/>
                            </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                <xsl:value-of select="@to"/>
                            </a>)<xsl:text/>
                        </span>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="locus/@scheme = 'folios'">
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme = 'pages'">
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:variable name="locusFrom" select="                             if (@from[contains(., ':')]) then                                 substring-before(@from, ':')                             else                                 if (@scheme = 'folios' and @from[not(contains(., 'r') or contains(., 'v'))]) then                                     (concat(@from, 'r'))                                 else                                     data(@from)"/>
                    <xsl:variable name="locusTo" select="                             if (@to[contains(., ':')]) then                                 substring-before(@to, ':')                             else                                 if (@scheme = 'folios' and @to[not(contains(., 'r') or contains(., 'v'))]) then                                     (concat(@to, 'r'))                                 else                                     data(@to)"/>
                    <xsl:variable name="locusFromIndex" select="count(//surface[@xml:id = concat(//TEI/@xml:id, '_', $locusFrom)]/preceding-sibling::*)"/>
                    <xsl:variable name="locusToIndex" select="count(//surface[@xml:id = concat(//TEI/@xml:id, '_', $locusTo)]/preceding-sibling::*)"/>
                    <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
                    <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>, </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                        <xsl:value-of select="@to"/>
                                    </a>, </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                        <xsl:value-of select="@from"/>
                                    </a>–<a class="facsimile" data-diva-index="{$locusToIndex}" href="#">
                                        <xsl:value-of select="@to"/>
                                    </a>
                                    <xsl:text/>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--<xsl:template match="locusGrp">
        <xsl:choose>
            <xsl:when test="parent::watermark">
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <!-\-<xsl:for-each select="locusGrp">-\->
                <xsl:for-each select="locus">
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>/</span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                        <xsl:value-of select="@to" />
                                    </a>/</span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                        <xsl:value-of select="@to" />
                                    </a></span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                <!-\-</xsl:for-each>-\->
                <xsl:if test="position() != last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:if test="position() = last()">
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <!-\-<xsl:apply-templates />-\->
            </xsl:when>
            <xsl:when test="parent::msItem">
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>(ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>(pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus"><a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>, </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus"><a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a>, </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <span class="locus"><a href="#{data(//msDesc/@xml:id)}-{data(@from)}"><xsl:value-of select="@from" /></a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}"><xsl:value-of select="@to" /></a>)<xsl:text> </xsl:text></span>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="locus/@scheme='folios'">
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme='pages'">
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:if test="position() != last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>, </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                        <xsl:value-of select="@to" />
                                    </a>, </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>
                                </span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="locus">
                                    <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                        <xsl:value-of select="@from" />
                                    </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                        <xsl:value-of select="@to" />
                                    </a><xsl:text> </xsl:text></span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    <xsl:template match="material">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="measure">
        <xsl:if test="@type = 'laidLinesIn20mm'">
            <em>Laid-lines in 20 mm : </em>
            <xsl:if test="@quantity">
                <xsl:value-of select="@quantity"/>
            </xsl:if>
            <xsl:if test="@min">
                <xsl:value-of select="@min"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="@max"/>
            </xsl:if>
            <xsl:if test="@unit = 'lines'">
                <xsl:text> </xsl:text>
                lines
            </xsl:if>
        </xsl:if>
        <xsl:if test="@type = 'folding'">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text> </xsl:text>
            folding
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    <!--<xsl:template match="msContents">
        <xsl:choose>
            <xsl:when test="parent::msPart">
                <xsl:for-each select="msItem">
                    <div class="msItem">
                        <span class="msItem_nr">
                            <xsl:number level="multiple" count="msItem" format="1.1" />
                            <xsl:text> </xsl:text>
                        </span>
                        <xsl:apply-templates select="node()[not(self::msItem)]" />
                        <!-\- Excludes msItems -\->
                        <xsl:for-each select="descendant::msItem">
                            <div class="sub_msItem">
                                <span class="msItem_nr">
                                    <xsl:number level="multiple" count="msItem" format="1.1" />
                                    <xsl:text> </xsl:text>
                                </span>
                                <xsl:apply-templates />
                            </div>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="parent::msDesc">
                <xsl:for-each select="msItem">
                    <div class="msItem">
                        <xsl:apply-templates />
                    </div>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->
    <xsl:template match="msContents">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="msDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- msIdentifier -->
    <!--<xsl:template match="msItem">
        <div class="msItem">
            <span id="item-{data(@n)}" class="msItem_nr">
                <xsl:value-of select="@n" />                
            </span>
            <xsl:apply-templates />
        </div>
    </xsl:template>-->

    <xsl:template match="msItem">
        <xsl:for-each select="descendant-or-self::msItem">
            <xsl:variable name="unit-nr">
                <xsl:value-of select="ancestor::msPart/msIdentifier/idno[@type = 'codicologicalUnit']"/>
            </xsl:variable>
            <xsl:variable name="item-nr">
                <xsl:number level="multiple" count="msItem" format="1.1"/>
            </xsl:variable>
            <div class="msItem">
                <span id="unit-{$unit-nr}-item-{$item-nr}" class="msItem_nr">
                    <xsl:value-of select="$item-nr"/>
                </span>
                <xsl:apply-templates select="node()[not(self::msItem)]"/>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="msName">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="msPart">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="musicNotation">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="nameLink">
        <span class="name">
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="parent::msItem">
                <div class="note">
                    <span class="head">Note: </span>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="parent::layout or ancestor::additions">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="num">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="objectDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <!--origDate, see date-->
    <xsl:template match="origPlace">
        <span class="origPlace">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="origin">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="parent::support or parent::additions">
                <div>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="persName">
        <!--<span class="persName">-->
        <xsl:choose>
            <xsl:when test="parent::author/parent::msItem">
                <span class="small-caps">
                    <xsl:choose>
                        <xsl:when test="@evidence = 'external' or @evidence = 'conjecture'">
                            <xsl:text>⟨</xsl:text>
                            <!-- Mathematical left angle bracket U+27E8 -->
                            <!--<xsl:apply-templates />-->
                            <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                                <xsl:value-of select="normalize-space(.)"/>
                            </a>
                            <!-- Removes whitespace before and after -->
                            <xsl:text>⟩</xsl:text>
                            <!-- Mathematical right angle bracket U+27E9 -->
                        </xsl:when>
                        <xsl:otherwise>
                            <!--<xsl:apply-templates />-->
                            <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                                <xsl:value-of select="normalize-space(.)"/>
                            </a>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                    <xsl:value-of select="normalize-space(.)"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
        <!--</span>-->
    </xsl:template>
    <xsl:template match="persName" mode="abbreviated-name">
        <xsl:apply-templates select="surname"/>
        <xsl:text>, </xsl:text>
        <xsl:for-each select="forename">
            <xsl:if test="position() != last()">
                <xsl:apply-templates select="." mode="abbreviated-name"/>
                <xsl:text/>
            </xsl:if>
            <xsl:if test="position() = last()">
                <xsl:apply-templates select="." mode="abbreviated-name"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="physDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="placeName">
        <!--<xsl:value-of select="normalize-space(.)" />-->
        <span class="placename">
            <!--<xsl:apply-templates />-->
            <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                <xsl:apply-templates/>
            </a>
        </span>
    </xsl:template>
    <xsl:template match="provenance">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="pubPlace">
        <span class="pubPlace">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- publicationStmt -->
    <xsl:template match="quote">
        <xsl:text>‘</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>’</xsl:text>
    </xsl:template>
    <xsl:template match="ref">
        <xsl:choose>
            <xsl:when test="@target">
                <a href="{data(@target)}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- repository -->
    <!-- resp -->
    <!-- respStmt -->
    <xsl:template match="respStmt">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="revisionDesc">
        <xsl:if test="@status = 'draft'">
            <div class="alert alert-danger alert-dismissible fade in" role="alert">
                <button class="close" aria-label="Close" data-dismiss="alert" type="button">
                    <span aria-hidden="true">×</span>
                </button>
                <p>
                    This description is a preliminary draft and is subject to change without notice
                </p>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="roleName">
        <span class="name">
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    <xsl:template match="rubric">
        <div class="rubric">
            <span class="head">Rubric: </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!-- settlement -->
    <xsl:template match="sic">
        <xsl:value-of select="."/>
        <xsl:text> (!)</xsl:text>
    </xsl:template>
    <xsl:template match="signatures">
        <xsl:if test="string-length(.) != 0">
            <div>
                <h5>Signatures: </h5>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="sponsor">
        <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <!-- sourceDesc -->
    <xsl:template match="summary">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="supplied">
        <xsl:text>⟨</xsl:text>
        <!-- Mathematical left angle bracket U+27E8 -->
        <xsl:value-of select="normalize-space(.)"/>
        <!-- Removes whitespace before and after -->
        <xsl:text>⟩</xsl:text>
        <!-- Mathematical right angle bracket U+27E9 -->
    </xsl:template>
    <xsl:template match="support">
        <xsl:apply-templates/>
        <!--<xsl:if test="count(p) gt 1">
            <xsl:for-each select="p">
                <xsl:number count="p" format="a" />
                <xsl:text>: </xsl:text>
                <xsl:apply-templates />
            </xsl:for-each>
        </xsl:if>-->
        <!--<xsl:apply-templates select="node()[not(self::watermark)]" />-->
        <!-- Excludes watermark -->
        <!--<div class="watermarks">
            <h4>Watermarks: </h4>
            <xsl:for-each select="p/watermark">
                <p>
                    <span class="watermark_nr"><xsl:value-of select="@n" />. </span>
                    <xsl:if test="locusGrp/locus/@scheme='folios'">
                        <xsl:text>ff. </xsl:text>
                    </xsl:if>
                    <xsl:if test="locusGrp/locus/@scheme='pages'">
                        <xsl:text>pp. </xsl:text>
                    </xsl:if>
                    <xsl:for-each select="locusGrp">
                        <xsl:for-each select="locus">
                            <xsl:if test="position() != last()">
                                <xsl:choose>
                                    <xsl:when test="@from = @to">
                                        <span class="locus">
                                            <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                                <xsl:value-of select="@from" />
                                            </a>/</span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="locus">
                                            <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                                <xsl:value-of select="@from" />
                                            </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                                <xsl:value-of select="@to" />
                                            </a>/</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                <xsl:choose>
                                    <xsl:when test="@from = @to">
                                        <span class="locus">
                                            <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                                <xsl:value-of select="@from" />
                                            </a>, 
                                                </span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="locus">
                                            <a href="#{data(//msDesc/@xml:id)}-{data(@from)}">
                                                <xsl:value-of select="@from" />
                                            </a>–<a href="#{data(//msDesc/@xml:id)}-{data(@to)}">
                                                <xsl:value-of select="@to" />
                                            </a>, </span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:text>. </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates />
                </p>
            </xsl:for-each>
        </div>-->
    </xsl:template>
    <xsl:template match="supportDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- surface -->
    <xsl:template match="surname">
        <span class="name">
            <xsl:value-of select="normalize-space(.)"/>
        </span>
    </xsl:template>
    <xsl:template match="surrogates">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- teiHeader -->
    <xsl:template match="term">
        <xsl:choose>
            <xsl:when test="@type = 'folding'">
                <em>Folding: </em>
                <xsl:apply-templates/>
                <xsl:text>. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text">
        <a name="{data(body/div/@xml:id)}"/>
        <h3>
            <xsl:value-of select="body/div/head/title"/>
        </h3>
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="body/div/head/locus"/>
        <xsl:text>) </xsl:text>
        <xsl:apply-templates select="body/div/p"/>
    </xsl:template>
    <!-- textLang -->
    <xsl:template match="title">
        <xsl:if test="parent::msItem">
            <xsl:if test="not(@type = 'alt')">
                <span class="italic spacing">
                    <!--<xsl:call-template name="makeLang"/>-->
                    <xsl:choose>
                        <xsl:when test="exists(@ref)">
                            <a href="{data(@ref)}">
                                <xsl:apply-templates/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:if>
            <xsl:if test="@type = 'alt'">
                <xsl:text> (</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:if test="@key">
                <span class="key">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="@key"/>
                    <xsl:text>) </xsl:text>
                </span>
            </xsl:if>
            <!--<xsl:if test="following-sibling::note/list[@type='toc']">
                <xsl:text> (</xsl:text>
                <xsl:apply-templates select="//list"/>
                <xsl:text>).</xsl:text>
            </xsl:if>-->
        </xsl:if>
        <xsl:if test="@level = 'a'">
            <xsl:choose>
                <xsl:when test="exists(preceding-sibling::ref)">
                    <a href="{data(preceding-sibling::ref/@target)}">
                        <xsl:text>‘</xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text>’</xsl:text>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="bibliography/{data(parent::bibl/@xml:id)}">
                        <xsl:text>‘</xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text>’</xsl:text>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="@level = 'm' or @level = 'u'">
            <span class="italic">
                <xsl:choose>
                    <xsl:when test="@type = 'short'">
                        <a href="{data(preceding-sibling::ref/@target)}" class="shortTitle" data-trigger="hover" data-toggle="popover" data-content="{data(preceding-sibling::title[@type='main'])}">
                            <xsl:apply-templates/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="exists(preceding-sibling::ref)">
                                <a href="{data(preceding-sibling::ref/@target)}">
                                    <xsl:apply-templates/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="bibliography/{data(parent::bibl/@xml:id)}">
                                    <xsl:apply-templates/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </xsl:if>
        <xsl:if test="@level = 'j'">
            <span class="bibl_journal_title">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
        <xsl:if test="@level = 's'">
            <span class="bibl_series_title">
                <xsl:apply-templates/>
            </span>
        </xsl:if>
        <xsl:if test="ancestor::list[@type = 'toc']">
            <em>
                <xsl:apply-templates/>
            </em>
        </xsl:if>
        <xsl:if test="@type = 'short'">
            <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                <xsl:apply-templates/>
            </a>
        </xsl:if>
    </xsl:template>
    <!-- titleStmt -->
    <xsl:template match="unclear">
        <xsl:text>[--- </xsl:text>
        <xsl:value-of select="@quantity"/>
        <xsl:text/>
        <xsl:value-of select="@unit"/>
        <xsl:text> ---]</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="watermark">
        <!--        <xsl:if test="watermark[string-length(.) != 0]">-->
        <div>
            <span class="watermark_nr">Watermark<xsl:text> </xsl:text>
                <xsl:value-of select="@n"/>. </span>
            <xsl:apply-templates/>
        </div>
        <!--</xsl:if>-->
    </xsl:template>
    <xsl:template match="width">
        <xsl:if test="@quantity">
            <xsl:value-of select="@quantity"/>
        </xsl:if>
        <xsl:if test="@min">
            <xsl:value-of select="@min"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@max"/>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="following-sibling::depth">
                <xsl:text> × </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> mm</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--<xsl:template match="exist:match" priority="10">
        <span class="hi">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>-->
    <!--<xsl:template match="exist:match" priority="10">
        <span style="background-color: yellow">
            <xsl:apply-templates/>
        </span>
    </xsl:template>-->
</xsl:stylesheet>