<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msg="urn:x-kosek:schemas:messages:1.0" xmlns:functx="http://www.functx.com" xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="msg" version="3.0">

    <xsl:output method="html" version="5.0" indent="yes" encoding="utf-8"/>

    <xsl:import href="functx-1.0-doc-2007-01.xsl"/>

    <xsl:template match="/">
        <main class="panel-group" id="msDescription">
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
                                    <xsl:text>digitized</xsl:text>
                                    <!--<xsl:choose>
                                        <!-\- Test if the number of images are greater than or equal to the number of textblock leaves * 2 -\->
                                        <xsl:when test="count(//facsimile/surface) ge sum(//measure[@type = 'textblockLeaves']/@quantity) * 2">
                                            <xsl:text>digitized</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>digitized_partly</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>-->
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>not_digitized</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="not(//msFrag)">
                                <xsl:value-of select="//repository, //msDesc/msIdentifier/idno[@type = 'shelfmark']" separator=", "/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="//msDesc/msIdentifier/idno[@type = 'shelfmark']"/>
                                <xsl:text> (</xsl:text>
                                <xsl:for-each select="//msFrag">
                                    <xsl:choose>
                                        <xsl:when test="position() != last()">
                                            <xsl:value-of select="msIdentifier/repository"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="msIdentifier/idno[@type = 'shelfmark']"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="msIdentifier/repository"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="msIdentifier/idno[@type = 'shelfmark']"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <xsl:text>)</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--<xsl:if test="//msIdentifier/altIdentifier/idno[@subtype = 'Access']">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="//msIdentifier/altIdentifier/idno[@subtype = 'Access']"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>-->
                    </h1>
                </div>
                <div>
                    <h1 class="small">
                        <xsl:value-of select="//msDesc/head"/>
                    </h1>
                    <p>
                        <xsl:if test="//origPlace">
                            <xsl:for-each select="distinct-values(//origPlace/placeName)">
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
                            <xsl:apply-templates select="distinct-values(//origDate)"/>
                            <xsl:if test="//origDate[@cert = 'low']">
                                <xsl:text> (?)</xsl:text>
                            </xsl:if>
                        </xsl:if>
                    </p>
                    <p>
                        <xsl:for-each select="distinct-values(//msPart//supportDesc/@material)">
                            <xsl:if test=". = 'paper'">
                                <xsl:text>papper</xsl:text>
                            </xsl:if>
                            <xsl:if test=". = 'parchment'">
                                <xsl:text>pergament</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="distinct-values(//msFrag//supportDesc/@material)">
                            <xsl:if test=". = 'paper'">
                                <xsl:text>Papier</xsl:text>
                            </xsl:if>
                            <xsl:if test=". = 'parchment'">
                                <xsl:text>Pergament</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </p>
                    <p>
                        <xsl:if test="//measure[@type = 'leftFlyleaves' and @quantity ge '1']">
                            <xsl:number format="i" value="//measure[@type = 'leftFlyleaves']/@quantity"/>
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <!--                        <xsl:value-of select="//measure[@type = 'textblockLeaves']/@quantity" separator=", "/>-->
                        <xsl:choose>
                            <xsl:when test="count(//msPart) eq 1 and not(matches(//measure[@type = 'textblockLeaves']/@quantity, '^\d{1,4}$'))">
                                <xsl:value-of select="//measure[@type = 'textblockLeaves']/@quantity"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="sum(//measure[@type = 'textblockLeaves']/@quantity)"/>
                            </xsl:otherwise>
                        </xsl:choose>
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
                            <xsl:text>enheter</xsl:text>
                        </p>
                    </xsl:if>
                    <p>
                        <xsl:if test="//msContents/textLang/@mainLang = 'grc'">
                            <xsl:text>Grekiska</xsl:text>
                        </xsl:if>
                        <xsl:if test="//msContents/textLang/@mainLang = 'la'">
                            <xsl:text>Latin</xsl:text>
                        </xsl:if>
                        <xsl:if test="//msContents/textLang/@mainLang = 'non-swe'">
                            <xsl:text>Fornsvenska</xsl:text>
                        </xsl:if>
                        <xsl:if test="//msContents/textLang/@mainLang = 'sv'">
                            <xsl:text>Svenska</xsl:text>
                        </xsl:if>
                    </p>
                </div>
            </section>
            <section class="msContents panel panel-default">
                <div class="panel-heading">
                    <h2 class="panel-title">
                        <a data-toggle="collapse" href="#msContents" aria-expanded="false" aria-controls="msContents" class="collapsed">
                            <xsl:text>Innehåll</xsl:text>
                        </a>
                    </h2>
                </div>
                <div id="msContents" class="panel-collapse collapse" role="tabpanel" aria-labelledby="msContents" aria-expanded="false">
                    <div class="panel-body">
                        <xsl:for-each select="//msPart">
                            <div>
                                <xsl:if test="count(//msPart) gt 1">
                                    <h3>
                                        <xsl:text>Enhet</xsl:text>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="msIdentifier/idno[@type = 'codicologicalUnit']/text()"/>
                                    </h3>
                                </xsl:if>
                                <xsl:apply-templates select="msContents"/>
                            </div>
                            <xsl:if test="not(.[not(following-sibling::msPart)])">
                                <hr class="hr-1"/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="//msFrag">
                            <h3>
                                <xsl:value-of select="msIdentifier/idno[@type = 'shelfmark']/text()"/>
                            </h3>
                            <xsl:apply-templates select="msContents"/>
                        </xsl:for-each>
                    </div>
                </div>
            </section>
            <section class="physDesc panel panel-default">
                <div class="panel-heading">
                    <h2 class="panel-title">
                        <a data-toggle="collapse" href="#physDesc" aria-expanded="false" aria-controls="physDesc" class="collapsed">
                            <xsl:text>Fysisk beskrivning</xsl:text>
                        </a>
                    </h2>
                </div>
                <div id="physDesc" class="panel-collapse collapse" role="tabpanel" aria-labelledby="physDesc" aria-expanded="false" style="height: 0px;">
                    <div class="panel-body">
                        <xsl:if test="//support[string-length(.) != 0]">
                            <div>
                                <h3>
                                    <xsl:text>Skriftunderlag</xsl:text>
                                </h3>
                                <xsl:for-each select="//support">
                                    <div>
                                        <xsl:choose>
                                            <xsl:when test="ancestor::msPart">
                                                <xsl:choose>
                                                    <xsl:when test="count(//msPart) gt 1">
                                                        <h4>
                                                            <xsl:text>Enhet</xsl:text>
                                                            <xsl:text> </xsl:text>
                                                            <xsl:number count="msPart"/>
                                                        </h4>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <h4>
                                                            <xsl:text>Textblock</xsl:text>
                                                        </h4>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:apply-templates select="p"/>
                                            </xsl:when>
                                            <xsl:when test="//msFrag">
                                                <h4>
                                                    <xsl:value-of select="ancestor::msFrag/msIdentifier/idno[@type = 'shelfmark']/text()"/>
                                                </h4>
                                                <xsl:apply-templates select="p"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <h4>
                                                    <xsl:text>Försättsblad</xsl:text>
                                                </h4>
                                                <xsl:apply-templates select="p"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </xsl:for-each>
                                <hr class="hr-2"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="//foliation[string-length(.) != 0]">
                            <div>
                                <h3>
                                    <xsl:text>Foliering</xsl:text>
                                </h3>
                                <xsl:for-each select="//foliation">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <div>
                                                <xsl:if test="count(//msPart) gt 1">
                                                    <h4>
                                                        <xsl:text>Enhet</xsl:text>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:number count="msPart"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:apply-templates/>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <xsl:apply-templates/>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </div>
                            <hr class="hr-2"/>
                        </xsl:if>
                        <xsl:if test="//collation/formula[string-length(.) != 0] or //collation/catchwords or //collation/signatures">
                            <div>
                                <h3>
                                    <xsl:text>Läggstruktur</xsl:text>
                                </h3>
                                <xsl:for-each select="//collation">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <div>
                                                <xsl:choose>
                                                    <xsl:when test="count(//msPart) gt 1">
                                                        <h4>
                                                            <xsl:text>Enhet</xsl:text>
                                                            <xsl:text> </xsl:text>
                                                            <xsl:number count="msPart"/>
                                                        </h4>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <h4>
                                                            <xsl:text>Textblock</xsl:text>
                                                        </h4>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:apply-templates/>
                                            </div>
                                            <xsl:if test="not(.[ancestor::msPart[not(following-sibling::msPart)]])">
                                                <hr class="hr-1"/>
                                            </xsl:if>
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
                                            <div>
                                                <h4>
                                                    <xsl:text>Försättsblad</xsl:text>
                                                </h4>
                                                <xsl:apply-templates/>
                                            </div>
                                            <hr class="hr-1"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <hr class="hr-2"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="//supportDesc/condition">
                            <div>
                                <h3>
                                    <xsl:text>Skick</xsl:text>
                                </h3>
                                <xsl:for-each select="//supportDesc/condition">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <div>
                                                <xsl:if test="count(//msPart) gt 1">
                                                    <h4>
                                                        <xsl:text>Enhet</xsl:text>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:number count="msPart"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:apply-templates/>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <h4>
                                                    <xsl:text>Försättsblad</xsl:text>: </h4>
                                                <xsl:apply-templates/>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <hr class="hr-2"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="//layoutDesc[string-length(.) != 0]">
                            <div>
                                <h3>
                                    <xsl:text>Layout</xsl:text>
                                </h3>
                                <xsl:for-each select="//layoutDesc">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <div>
                                                <xsl:if test="count(//msPart) gt 1">
                                                    <h4>
                                                        <xsl:text>Enhet</xsl:text>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:number count="msPart"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:apply-templates select="layout"/>
                                            </div>
                                        </xsl:when>
                                        <xsl:when test="//msFrag">
                                            <div>
                                                <h4>
                                                    <xsl:value-of select="ancestor::msFrag/msIdentifier/idno[@type = 'shelfmark']/text()"/>
                                                </h4>
                                            </div>
                                            <xsl:apply-templates select="layout"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <xsl:apply-templates select="layout"/>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <hr class="hr-2"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="//handDesc[string-length(.) != 0]">
                            <div>
                                <h3>
                                    <xsl:text>Skrift</xsl:text>
                                </h3>
                                <xsl:for-each select="//handDesc">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <div>
                                                <xsl:choose>
                                                    <xsl:when test="count(//msPart) gt 1">
                                                        <h4>
                                                            <xsl:text>Enhet</xsl:text>
                                                            <xsl:text> </xsl:text>
                                                            <xsl:number count="msPart"/>
                                                        </h4>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <h4>
                                                            <xsl:text>Textblock</xsl:text>
                                                        </h4>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:apply-templates select="handNote"/>
                                            </div>
                                        </xsl:when>
                                        <xsl:when test="//msFrag">
                                            <div>
                                                <h4>
                                                    <xsl:value-of select="ancestor::msFrag/msIdentifier/idno[@type = 'shelfmark']/text()"/>
                                                </h4>
                                            </div>
                                            <xsl:apply-templates/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <h4>
                                                    <xsl:text>Bokblock</xsl:text>
                                                </h4>
                                                <xsl:apply-templates select="handNote"/>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <hr class="hr-2"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="//additions[string-length(.) != 0]">
                            <div>
                                <h3>
                                    <xsl:text>Tillägg</xsl:text>
                                </h3>
                                <xsl:for-each select="//additions">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <xsl:choose>
                                                <xsl:when test="count(//msPart) gt 1">
                                                    <h4>
                                                        <xsl:text>Enhet</xsl:text>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:number count="msPart"/>
                                                    </h4>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <h4>
                                                        <xsl:text>Textblock</xsl:text>
                                                    </h4>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:apply-templates/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <h4>
                                                <xsl:text>Försättsblad</xsl:text>
                                            </h4>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <hr class="hr-2"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="//decoDesc[string-length(.) != 0]">
                            <div>
                                <h3>
                                    <xsl:text>Dekorationer</xsl:text>
                                </h3>
                                <xsl:for-each select="//decoDesc">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::msPart">
                                            <div>
                                                <xsl:if test="count(//msPart) gt 1">
                                                    <h4>
                                                        <xsl:text>Enhet</xsl:text>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:number count="msPart"/>
                                                    </h4>
                                                </xsl:if>
                                                <xsl:apply-templates select="decoNote | p"/>
                                            </div>
                                            <xsl:if test="not(.[ancestor::msPart[not(following-sibling::msPart)]])">
                                                <hr class="hr-1"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <h4>
                                                    <xsl:text>Textblock</xsl:text>: </h4>
                                                <xsl:apply-templates select="decoNote | p"/>
                                            </div>
                                            <hr class="hr-1"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <hr class="hr-2"/>
                            </div>
                        </xsl:if>
                        <xsl:if test="//bindingDesc[string-length(.) != 0]">
                            <div>
                                <h3>
                                    <xsl:text>Bokband</xsl:text>
                                </h3>
                                <xsl:apply-templates select="//bindingDesc"/>
                            </div>
                        </xsl:if>
                    </div>
                </div>
            </section>
            <section class="history panel panel-default">
                <div class="panel-heading">
                    <h2 class="panel-title">
                        <a data-toggle="collapse" href="#history" aria-expanded="false" aria-controls="history" class="collapsed">
                            <xsl:text>Historia</xsl:text>
                        </a>
                    </h2>
                </div>
                <div id="history" class="panel-collapse collapse" role="tabpanel" aria-labelledby="history" aria-expanded="false" style="height: 0px;">
                    <div class="panel-body">
                        <xsl:call-template name="history"/>
                    </div>
                </div>
            </section>
            <section class="additional panel panel-default">
                <div class="panel-heading">
                    <h2 class="panel-title">
                        <a data-toggle="collapse" href="#additional" aria-expanded="false" aria-controls="additional" class="collapsed">
                            <xsl:text>Bibliografi</xsl:text>
                        </a>
                    </h2>
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
                    <h2 class="panel-title">
                        <a data-toggle="collapse" href="#metadata" aria-expanded="false" aria-controls="metadata" class="collapsed">
                            <xsl:text>Metadata</xsl:text>
                        </a>
                    </h2>
                </div>
                <div id="metadata" class="panel-collapse collapse" role="tabpanel" aria-labelledby="metadata" aria-expanded="false" style="height: 0px;">
                    <div class="panel-body">
                        <div>
                            <h3>
                                <xsl:text>Upphovsuppgift</xsl:text>
                            </h3>
                            <div>
                                <xsl:if test="//respStmt/resp[@key = 'cataloguer']">
                                    <xsl:text>Katalogisering</xsl:text>
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
                                    <xsl:text>Kodning</xsl:text>
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
                                <xsl:text>Sponsor</xsl:text>
                                <xsl:text>: </xsl:text>
                                <xsl:for-each select="//sponsor">
                                    <xsl:apply-templates select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </div>
                            <div>
                                <xsl:text>Finansiär</xsl:text>
                                <xsl:text>: </xsl:text>
                                <xsl:for-each select="//funder">
                                    <xsl:apply-templates select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </div>
                            <hr class="hr-2"/>
                        </div>
                        <xsl:if test="//idno[@type = 'id'][@subtype = 'Diktyon'] or //idno[@type = 'id'][@subtype = 'Libris'] or //idno[@type = 'id'][@subtype = 'Alvin']">
                            <div>
                                <h3>
                                    <xsl:text>Externa identifikatorer</xsl:text>
                                </h3>
                                <xsl:if test="//idno[@type = 'id'][@subtype = 'Diktyon']">
                                    <div>
                                        <xsl:text>Diktyon ID</xsl:text>
                                        <xsl:text>: </xsl:text>
                                        <a href="http://pinakes.irht.cnrs.fr/notices/cote/{data(//idno[@type = 'id'][@subtype='Diktyon'])}/" target="_blank">
                                            <xsl:value-of select="//idno[@type = 'id'][@subtype = 'Diktyon']"/>
                                        </a>
                                    </div>
                                </xsl:if>
                                <xsl:if test="//idno[@type = 'id'][@subtype = 'Libris']">
                                    <div>
                                        <xsl:text>Libris ID</xsl:text>
                                        <xsl:text>: </xsl:text>
                                        <a href="http://libris.kb.se/bib/{data(//idno[@type = 'id'][@subtype='Libris'])}" target="_blank">
                                            <xsl:text>http://libris.kb.se/bib/</xsl:text>
                                            <xsl:value-of select="//idno[@type = 'id'][@subtype = 'Libris']"/>
                                        </a>
                                    </div>
                                    <div>
                                        <xsl:text>Digitalisering</xsl:text>
                                        <xsl:text>: </xsl:text>
                                        <a href="https://weburn.kb.se/metadata/{data(substring(//idno[@type = 'id'][@subtype='Libris'], string-length(//idno[@type = 'id'][@subtype='Libris']) - 2))}/hs_{data(//idno[@type = 'id'][@subtype='Libris'])}.htm" target="_blank">
                                            <xsl:text>PDF</xsl:text>
                                        </a>
                                    </div>
                                </xsl:if>
                                <xsl:if test="//idno[@type = 'id'][@subtype = 'Alvin']">
                                    <div>
                                        <xsl:text>Alvin ID</xsl:text>
                                        <xsl:text>: </xsl:text>
                                        <a href="https://www.alvin-portal.org/alvin/view.jsf?pid={data(//idno[@type = 'id'][@subtype='Alvin'])}" target="_blank">
                                            <xsl:value-of select="//idno[@type = 'id'][@subtype = 'Alvin']"/>
                                        </a>
                                    </div>
                                </xsl:if>
                            </div>
                        </xsl:if>
                        <div>
                            <h3>
                                <xsl:text>Interna identifikatorer</xsl:text>
                            </h3>
                            <div>
                                <xsl:text>Permalänk</xsl:text>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="//idno[@subtype = 'Manuscripta']"/>
                            </div>
                            <div>
                                <xsl:text>XML</xsl:text>
                                <xsl:text>: </xsl:text>
                                <a href="/ms/{data(substring-after(TEI/@xml:id, 'ms-'))}.xml">
                                    <xsl:text>https://www.manuscripta.se/ms/</xsl:text>
                                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'ms-'))"/>
                                    <xsl:text>.xml</xsl:text>
                                </a>
                            </div>
                        </div>
                        <xsl:if test="//facsimile">
                            <div>
                                <xsl:text>IIIF manifest</xsl:text>
                                <xsl:text>: </xsl:text>
                                <a href="/iiif/{data(substring-after(TEI/@xml:id, 'ms-'))}/manifest.json">
                                    <xsl:text>https://www.manuscripta.se/iiif/</xsl:text>
                                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'ms-'))"/>
                                    <xsl:text>/manifest.json</xsl:text>
                                </a>
                                <hr class="hr-2"/>
                            </div>
                        </xsl:if>
                        <div>
                            <h3>
                                <xsl:text>Licens</xsl:text>
                            </h3>
                            <div>
                                <xsl:text>Beskrivning</xsl:text>
                                <xsl:text>: </xsl:text>
                                <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"> CC BY 4.0</a>
                            </div>
                            <xsl:if test="//facsimile">
                                <div>
                                    <xsl:text>Bilder</xsl:text>
                                    <xsl:text>: </xsl:text>
                                    <a href="https://creativecommons.org/publicdomain/zero/1.0/">Public Domain</a>
                                </div>
                            </xsl:if>
                            <hr class="hr-2"/>
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
        <div class="pb-2">
            <xsl:apply-templates/>
        </div>
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
                <div class="pl-2">
                    <label>
                        <xsl:text>Utgåva</xsl:text>: </label>
                    <xsl:apply-templates select="title"/>
                    <xsl:text>, </xsl:text>
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
            <xsl:when test="parent::listBibl/parent::msItem">
                <xsl:apply-templates select="title"/>
                <xsl:text>, </xsl:text>
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
                <xsl:if test="following-sibling::bibl">
                    <xsl:text>; </xsl:text>
                </xsl:if>
                <xsl:if test="not(following-sibling::bibl)">
                    <xsl:text>.</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="ancestor::watermark">
                <xsl:apply-templates select="title"/>
                <xsl:text>, </xsl:text>
                <xsl:for-each select="citedRange">
                    <xsl:if test="position() != last()">
                        <xsl:apply-templates select="."/>
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:if test="position() = last()">
                        <xsl:apply-templates select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="title"/>
                <xsl:text>, </xsl:text>
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
                                <xsl:text>vol.</xsl:text>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@from"/>
                                <xsl:text>, </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>vol.</xsl:text>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                                <xsl:text>, </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="@from = @to">
                                <xsl:text>vol.</xsl:text>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@from"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>vol.</xsl:text>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit = 'page'">
                <xsl:choose>
                    <xsl:when test="not(following-sibling::citedRange[@unit = 'page']) and not(preceding-sibling::citedRange[@unit = 'page'])">
                        <xsl:if test="not(@from = @to)">
                            <xsl:text>s.</xsl:text>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:if test="@from = @to">
                            <xsl:text>s.</xsl:text>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(preceding-sibling::citedRange[@unit = 'page'])">
                            <xsl:text>s.</xsl:text>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <xsl:value-of select="@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit = 'column'">
                <xsl:choose>
                    <xsl:when test="not(following-sibling::citedRange[@unit = 'column']) and not(preceding-sibling::citedRange[@unit = 'column'])">
                        <xsl:if test="not(@from = @to)">
                            <xsl:text>sp.</xsl:text>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:if test="@from = @to">
                            <xsl:text>sp.</xsl:text>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(preceding-sibling::citedRange[@unit = 'column'])">
                            <xsl:text>sp.</xsl:text>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <xsl:value-of select="@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit = 'folio'">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <xsl:text>f. </xsl:text>
                        <xsl:value-of select="@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>ff. </xsl:text>
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
                        <xsl:text>nr</xsl:text>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>nr</xsl:text>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@unit = 'plate'">
                <xsl:choose>
                    <xsl:when test="@from = @to">
                        <xsl:text>plansch</xsl:text>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>plansch</xsl:text>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@from"/>–<xsl:value-of select="@to"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::watermark">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
                <!--                <xsl:apply-templates />-->
            </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:if test="not(following::citedRange)">
            <xsl:text>.</xsl:text>
        </xsl:if>-->
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
                <label>
                    <xsl:text>Kustoder</xsl:text>: </label>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
    </xsl:template>
    <xsl:template match="change">
        <xsl:if test="position() = 1">
            <xsl:text>Senast ändrad</xsl:text>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@when"/>
        </xsl:if>
    </xsl:template>
    <!--  CitedRange, see biblScope  -->
    <xsl:template match="collation">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="collation/p">
        <label>
            <xsl:text>Anmärkning</xsl:text>: </label>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="colophon">
        <div class="pl-2">
            <label>
                <xsl:text>Kolofon</xsl:text>: </label>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="condition">
        <div>
            <label>
                <xsl:text>Skick</xsl:text>: </label>
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
            <xsl:if test="@cert = 'low'">
                <xsl:text> (?)</xsl:text>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template match="decoDesc">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="decoNote">
        <div>
            <xsl:if test="@type = 'bookmarks'">
                <label>
                    <xsl:text>Bokmärken</xsl:text>: </label>
            </xsl:if>
            <xsl:if test="@type = 'edges'">
                <label>
                    <xsl:text>Snitt</xsl:text>: </label>
            </xsl:if>
            <xsl:if test="@type = 'endbands'">
                <label>
                    <xsl:text>Kapitälband</xsl:text>: </label>
            </xsl:if>
            <xsl:if test="@type = 'illuminations'">
                <label>
                    <xsl:text>Illumineringar</xsl:text>: </label>
            </xsl:if>
            <xsl:if test="@type = 'image'">
                <label>
                    <xsl:text>Bild</xsl:text>: </label>
            </xsl:if>
            <xsl:if test="@type = 'initials'">
                <label>
                    <xsl:text>Initialer</xsl:text>: </label>
            </xsl:if>
            <xsl:if test="@type = 'lombards'">
                <label>
                    <xsl:text>Lombarder</xsl:text>: </label>
            </xsl:if>
            <xsl:if test="@type = 'tooling'">
                <label>
                    <xsl:text>Pärmstämplar</xsl:text>: </label>
            </xsl:if>
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
            <label>
                <xsl:text>Skriftyta</xsl:text>: </label>
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:if test="@type = 'binding'">
            <label>
                <xsl:text>Mått på bokband</xsl:text>: </label>
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:if test="@type = 'watermark'">
            <div>
                <label>
                    <xsl:text>Mått på vattenmärke</xsl:text>: </label>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
        <xsl:if test="@type = 'chainLines'">
            <div>
                <xsl:for-each select=".[@type = 'chainLines']">
                    <label>
                        <xsl:text>Kedjelinjer</xsl:text>: </label>
                    <xsl:apply-templates select="width"/>
                </xsl:for-each>
            </div>
        </xsl:if>
        <xsl:if test="@type = 'leaf'">
            <div>
                <label>
                    <xsl:text>Bladstorlek</xsl:text>: </label>
                <xsl:apply-templates/>
            </div>
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
        <div class="pl-2">
            <label>
                <xsl:text>Explicit</xsl:text>: </label>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="extent">
        <xsl:apply-templates/>
    </xsl:template>
    <!--  facsimile  -->
    <!--  fileDesc  -->
    <xsl:template match="filiation">
        <div class="pl-2">
            <xsl:if test="@type = 'protograph'">
                <label>
                    <xsl:text>Förlaga</xsl:text>: </label>
                <xsl:apply-templates/>
            </xsl:if>
            <xsl:if test="@type = 'apograph'">
                <label>
                    <xsl:text>Avskrift</xsl:text>: </label>
                <xsl:apply-templates/>
            </xsl:if>
            <xsl:if test="@type = 'siglum'">
                <label>
                    <xsl:text>Sigla</xsl:text>: </label>
                <xsl:apply-templates/>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="finalRubric">
        <div class="pl-2">
            <label>
                <xsl:text>Slutrubrik</xsl:text>: </label>
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
        <xsl:if test="string-length(.) != 0">
            <div>
                <label>
                    <xsl:text>Formel</xsl:text>: </label>
                <xsl:apply-templates/>
            </div>
        </xsl:if>
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
        <xsl:choose>
            <xsl:when test="@sameAs">
                <div class="pb-2">
                    <h5>Hand <xsl:value-of select="substring-after(@sameAs, '#hand-')"/>
                    </h5>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="pb-2">
                    <h5>Hand <xsl:value-of select="substring-after(@xml:id, 'hand-')"/>
                    </h5>
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(ancestor::msPart) or not(.[ancestor::msPart[not(following-sibling::msPart)]])">
            <hr class="hr-1"/>
        </xsl:if>
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
        <xsl:if test="//origin">
            <div>
                <h3>
                    <xsl:text>Ursprung</xsl:text>
                </h3>
                <xsl:if test="//msDesc/history/origin">
                    <div>
                        <xsl:apply-templates select="//msDesc/history/origin"/>
                    </div>
                </xsl:if>
                <xsl:for-each select="//msPart/history/origin">
                    <div>
                        <xsl:if test="count(//msPart) gt 1">
                            <h4>
                                <xsl:text>Enhet</xsl:text>
                                <xsl:text> </xsl:text>
                                <xsl:number count="msPart"/>
                            </h4>
                        </xsl:if>
                        <xsl:apply-templates select="."/>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="//msFrag/history/origin">
                    <div>
                        <h4>
                            <xsl:value-of select="ancestor::msFrag/msIdentifier/idno[@type = 'shelfmark']/text()"/>
                        </h4>
                        <xsl:apply-templates select="."/>
                    </div>
                </xsl:for-each>
                <hr class="hr-2"/>
            </div>
        </xsl:if>
        <xsl:if test="//provenance">
            <div>
                <h3>
                    <xsl:text>Proveniens</xsl:text>
                </h3>
                <xsl:for-each select="//provenance">
                    <div>
                        <xsl:apply-templates select="."/>
                    </div>
                </xsl:for-each>
                <hr class="hr-2"/>
            </div>
        </xsl:if>
        <!--<div class="formerShelfmarks">
            <xsl:apply-templates select="//idno" />
        </div>-->
        <xsl:if test="//acquisition">
            <div>
                <h3>
                    <xsl:text>Förvärv</xsl:text>
                </h3>
                <xsl:apply-templates select="//acquisition"/>
            </div>
            <xsl:if test="//altIdentifier/idno[@type = 'formerShelfmark']">
                <hr class="hr-2"/>
            </xsl:if>
        </xsl:if>
        <xsl:if test="//altIdentifier/idno[@type = 'formerShelfmark']">
            <h3>
                <xsl:text>Äldre signum</xsl:text>
            </h3>
            <xsl:for-each select="//altIdentifier/idno[@type = 'formerShelfmark']">
                <div>
                    <xsl:value-of select="."/>
                </div>
                <!--<xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:value-of select="."/>
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>-->
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="idno">
        <xsl:choose>
            <!--<xsl:when test="@type = 'formerShelfmark'">
                <h3><msg:Former_shelfmarks />: </h3>
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
        <div class="pl-2">
            <label>
                <xsl:text>Incipit</xsl:text>: </label>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <!-- institution -->
    <!-- item -->
    <xsl:template match="layout">
        <div class="pb-2">
            <h5>
                <xsl:text>Layout</xsl:text>
                <xsl:text> </xsl:text>
                <xsl:value-of select="position()"/>
            </h5>
            <div>
                <xsl:apply-templates select="locus | locusGrp"/>
            </div>
            <!-- Only show columns when greater than 1 -->
            <!--            <xsl:if test="@columns[. gt '1']">-->
            <xsl:if test="@columns">
                <div>
                    <label>
                        <xsl:text>Kolumner</xsl:text>: </label>
                    <xsl:value-of select="@columns"/>
                </div>
            </xsl:if>
            <xsl:if test="@ruledLines">
                <div>
                    <label>
                        <xsl:text>Linjerade rader</xsl:text>: </label>
                    <xsl:choose>
                        <!-- Check for min and max values -->
                        <xsl:when test="substring(@ruledLines, 4, 5)">
                            <xsl:value-of select="concat(substring(@ruledLines, 1, 2), '–', substring(@ruledLines, 4, 5))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(@ruledLines, 1, 2)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <!--<xsl:text> </xsl:text>
                    <msg:ruled_lines/>
                    <xsl:text>,</xsl:text>-->
            </xsl:if>
            <xsl:if test="@writtenLines">
                <div>
                    <label>
                        <xsl:text>Skrivna rader</xsl:text>: </label>
                    <xsl:choose>
                        <!-- Check for min and max values -->
                        <xsl:when test="substring(@writtenLines, 4, 5)">
                            <xsl:value-of select="concat(substring(@writtenLines, 1, 2), '–', substring(@writtenLines, 4, 5))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(@writtenLines, 1, 2)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--<xsl:text> </xsl:text>
                    <msg:written_lines/>
                    <xsl:text>. </xsl:text>-->
                </div>
            </xsl:if>
            <xsl:if test="dimensions">
                <div>
                    <xsl:apply-templates select="dimensions"/>
                </div>
            </xsl:if>
            <xsl:if test="note">
                <div>
                    <xsl:apply-templates select="note"/>
                </div>
            </xsl:if>
        </div>
        <xsl:if test="not(ancestor::msPart) or not(.[ancestor::msPart[not(following-sibling::msPart)]])">
            <hr class="hr-1"/>
        </xsl:if>
    </xsl:template>
    <!--<xsl:template match="layoutDesc">
        <xsl:apply-templates/>
    </xsl:template>-->
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
                <div class="pl-2">
                    <label>
                        <xsl:text>Utgåvor</xsl:text>: </label>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="parent::additional">
                <ul>
                    <xsl:for-each select="bibl">
                        <li>
                            <xsl:apply-templates select="."/>
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
        <xsl:if test="parent::p/parent::support or parent::watermark/parent::p/parent::support or parent::layout">
            <label>
                <xsl:text>Lokalisering</xsl:text>: </label>
        </xsl:if>
        <!--<xsl:variable name="locusFrom" select="if (@from[contains(.,':')]) then substring-before(@from,':') else if (@from[matches(.,'^\d{1,}$')]) then (concat(@from,'r')) else data(@from)" />
        <xsl:variable name="locusTo" select="if (@to[contains(.,':')]) then substring-before(@to,':') else if (@to[matches(.,'^\d{1,}$')]) then (concat(@to,'r')) else data(@to)" />-->
        <xsl:variable name="locusFrom" select="                 if (@from[contains(., ':')]) then                     substring-before(@from, ':')                 else                     if (@from[ends-with(., 'a')]) then                         substring-before(@from, 'a')                     else                         if (@from[ends-with(., 'b')]) then                             substring-before(@from, 'b')                         else                             if (@scheme = 'folios' and @from[not(contains(., 'r') or contains(., 'v'))]) then                                 (concat(@from, 'r'))                             else                                 data(@from)"/>
        <xsl:variable name="locusTo" select="                 if (@to[contains(., ':')]) then                     substring-before(@to, ':')                 else                     if (@to[ends-with(., 'a')]) then                         substring-before(@to, 'a')                     else                         if (@to[ends-with(., 'b')]) then                             substring-before(@to, 'b')                         else                             if (@scheme = 'folios' and @to[not(contains(., 'r') or contains(., 'v'))]) then                                 (concat(@to, 'r'))                             else                                 data(@to)"/>
        <!--<xsl:variable name="locusFromURL" select="//surface[@xml:id=concat(//TEI/@xml:id,'_',$locusFrom)]/graphic/@url"/>-->
        <xsl:variable name="locusFromIndex" select="count(//surface[functx:substring-after-last(@xml:id , '_') = $locusFrom]/preceding-sibling::*)"/>
        <!--<xsl:variable name="locusToURL" select="//surface[@xml:id=concat(//TEI/@xml:id,'_',$locusTo)]/graphic/@url"/>-->
        <xsl:variable name="locusToIndex" select="count(//surface[functx:substring-after-last(@xml:id , '_') = $locusTo]/preceding-sibling::*)"/>
        <xsl:choose>
            <xsl:when test="parent::msItem or parent::handNote or ancestor::additions or ancestor::decoDesc">
                <xsl:if test="@scheme = 'folios'">
                    <xsl:choose>
                        <xsl:when test="@from = @to">
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
                            <span class="locus">(<xsl:text>s.</xsl:text>
                                <a class="facsimile" data-diva-index="{$locusFromIndex}" href="#">
                                    <xsl:value-of select="@from"/>
                                </a>)<xsl:text/>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="locus">(<xsl:text>s.</xsl:text>
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
        <xsl:if test="parent::p/parent::support or parent::layout">
            <label>
                <xsl:text>Lokalisering</xsl:text>: </label>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="parent::watermark">
                <xsl:if test="locus/@scheme = 'folios' and not(preceding-sibling::locusGrp)">
                    <label>
                        <xsl:text>Lokalisering</xsl:text>: </label>
                    <xsl:text>ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme = 'pages' and not(preceding-sibling::locusGrp)">
                    <label>
                        <xsl:text>Lokalisering</xsl:text>: </label>
                    <xsl:text>pp. </xsl:text>
                </xsl:if>
                <!--<xsl:for-each select="locusGrp">-->
                <xsl:for-each select="locus">
                    <xsl:variable name="locusFrom" select="                             if (@from[contains(., ':')]) then                                 substring-before(@from, ':')                             else                                 if (@from[ends-with(., 'a')]) then                                     substring-before(@from, 'a')                                 else                                     if (@from[ends-with(., 'b')]) then                                         substring-before(@from, 'b')                                     else                                         if (@scheme = 'folios' and @from[not(contains(., 'r') or contains(., 'v'))]) then                                             (concat(@from, 'r'))                                         else                                             data(@from)"/>
                    <xsl:variable name="locusTo" select="                             if (@to[contains(., ':')]) then                                 substring-before(@to, ':')                             else                                 if (@to[ends-with(., 'a')]) then                                     substring-before(@to, 'a')                                 else                                     if (@to[ends-with(., 'b')]) then                                         substring-before(@to, 'b')                                     else                                         if (@scheme = 'folios' and @to[not(contains(., 'r') or contains(., 'v'))]) then                                             (concat(@to, 'r'))                                         else                                             data(@to)"/>
                    <xsl:variable name="locusFromIndex" select="count(//surface[functx:substring-after-last(@xml:id , '_') = $locusFrom]/preceding-sibling::*)"/>
                    <xsl:variable name="locusToIndex" select="count(//surface[functx:substring-after-last(@xml:id , '_') = $locusTo]/preceding-sibling::*)"/>
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
            <xsl:when test="parent::msItem or parent::handNote or ancestor::additions">
                <xsl:if test="locus/@scheme = 'folios'">
                    <xsl:text>(ff. </xsl:text>
                </xsl:if>
                <xsl:if test="locus/@scheme = 'pages'">
                    <xsl:text>(pp. </xsl:text>
                </xsl:if>
                <xsl:for-each select="locus">
                    <xsl:variable name="locusFrom" select="                             if (@from[contains(., ':')]) then                                 substring-before(@from, ':')                             else                                 if (@scheme = 'folios' and @from[not(contains(., 'r') or contains(., 'v'))]) then                                     (concat(@from, 'r'))                                 else                                     data(@from)"/>
                    <xsl:variable name="locusTo" select="                             if (@to[contains(., ':')]) then                                 substring-before(@to, ':')                             else                                 if (@scheme = 'folios' and @to[not(contains(., 'r') or contains(., 'v'))]) then                                     (concat(@to, 'r'))                                 else                                     data(@to)"/>
                    <xsl:variable name="locusFromIndex" select="count(//surface[functx:substring-after-last(@xml:id , '_') = $locusFrom]/preceding-sibling::*)"/>
                    <xsl:variable name="locusToIndex" select="count(//surface[functx:substring-after-last(@xml:id , '_') = $locusTo]/preceding-sibling::*)"/>
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
                    <xsl:variable name="locusFromIndex" select="count(//surface[functx:substring-after-last(@xml:id , '_') = $locusFrom]/preceding-sibling::*)"/>
                    <xsl:variable name="locusToIndex" select="count(//surface[functx:substring-after-last(@xml:id , '_') = $locusTo]/preceding-sibling::*)"/>
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
        <xsl:choose>
            <xsl:when test="ancestor::support">
                <div>
                    <label>
                        <xsl:text>Skriftunderlag</xsl:text>: </label>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="measure">
        <xsl:if test="@type = 'laidLinesIn20mm'">
            <div>
                <label>
                    <xsl:text>Lagda linjer per 20 mm</xsl:text>: </label>
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
                    <xsl:text>rader</xsl:text>
                </xsl:if>
            </div>
        </xsl:if>
        <xsl:if test="@type = 'folding'">
            <div>
                <label>
                    <xsl:text>Format</xsl:text>: </label>
                <xsl:value-of select="."/>
            </div>
        </xsl:if>
        <xsl:if test="@type = 'textblockLeaves'">
            <div>
                <label>
                    <xsl:text>Omfång</xsl:text>: </label>
                <xsl:value-of select="@quantity"/>
            </div>
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

    <xsl:template match="msFrag">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="msItem">
        <xsl:for-each select="descendant-or-self::msItem">
            <xsl:variable name="unit-nr">
                <xsl:value-of select="ancestor::msPart/msIdentifier/idno[@type = 'codicologicalUnit']"/>
            </xsl:variable>
            <xsl:variable name="item-nr">
                <xsl:number level="multiple" count="msItem" format="1.1"/>
            </xsl:variable>
            <div class="pb-4">
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
                <div class="pl-2">
                    <label>
                        <xsl:text>Anmärkning</xsl:text>: </label>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="parent::layout">
                <div>
                    <label>
                        <xsl:text>Anmärkning</xsl:text>: </label>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="ancestor::additions">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="parent::handNote">
                <xsl:choose>
                    <xsl:when test="@type = 'script'">
                        <div>
                            <label>
                                <xsl:text>Skrifttyp</xsl:text>: </label>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:when>
                    <xsl:when test="@type = 'scribe'">
                        <div>
                            <label>
                                <xsl:text>Skrivare</xsl:text>: </label>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:when>
                    <xsl:when test="@type = 'medium'">
                        <div>
                            <label>
                                <xsl:text>Skriftfärg</xsl:text>: </label>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div>
                            <label>
                                <xsl:text>Anmärkning</xsl:text>: </label>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::binding">
                <xsl:choose>
                    <xsl:when test="@type = 'description'">
                        <div>
                            <label>
                                <xsl:text>Beskrivning</xsl:text>: </label>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:when>
                    <xsl:when test="@type = 'binding-date'">
                        <div>
                            <label>
                                <xsl:text>Bokbandsdatering</xsl:text>: </label>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div>
                            <label>
                                <xsl:text>Anmärkning</xsl:text>: </label>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <label>
                        <xsl:text>Anmärkning</xsl:text>: </label>
                    <xsl:apply-templates/>
                </div>
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
    <xsl:template match="orgName">
        <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="origPlace">
        <xsl:for-each select="placeName">
            <xsl:apply-templates select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="origin">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="parent::support">
                <div class="pb-2">
                    <h5>
                        <xsl:text>Skriftunderlag</xsl:text>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="position()"/>
                    </h5>
                    <xsl:apply-templates/>
                </div>
                <xsl:if test="not(ancestor::msPart) or not(.[parent::support/ancestor::msPart[not(following-sibling::msPart)]])">
                    <hr class="hr-1"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="parent::additions or parent::decoDesc">
                <div class="pb-2">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="parent::binding and not(child::dimensions)">
                <div>
                    <label>
                        <xsl:text>Beskrivning</xsl:text>: </label>
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
                            <xsl:choose>
                                <xsl:when test="@ref">
                                    <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- Removes whitespace before and after -->
                            <xsl:text>⟩</xsl:text>
                            <!-- Mathematical right angle bracket U+27E9 -->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="@ref">
                                    <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
                <xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@ref">
                        <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                            <xsl:value-of select="normalize-space(.)"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:otherwise>
                </xsl:choose>
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
        <div class="pb-2">
            <xsl:apply-templates/>
        </div>
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
                    <xsl:text>Denna beskrivning är ett preliminärt utkast och kan ändras utan förvarning</xsl:text>
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
        <div class="pl-2">
            <label>
                <xsl:text>Rubrik</xsl:text>: </label>
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
                <label>
                    <xsl:text>Läggsignaturer</xsl:text>: </label>
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
        <xsl:for-each select="p">
            <xsl:apply-templates/>
        </xsl:for-each>

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
            <h3>Watermarks: </h3>
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
            <xsl:when test="@type = 'watermarkMotif'">
                <div>
                    <label>
                        <xsl:text>Motiv</xsl:text>: </label>
                    <!--<xsl:apply-templates/>-->
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@type = 'proximity'">
                <xsl:apply-templates select="node() | ref"/>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text">
        <a name="{data(body/div/@xml:id)}"/>
        <h2>
            <xsl:value-of select="body/div/head/title"/>
        </h2>
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="body/div/head/locus"/>
        <xsl:text>) </xsl:text>
        <xsl:apply-templates select="body/div/p"/>
    </xsl:template>
    <!-- textLang -->
    <xsl:template match="title">
        <xsl:if test="parent::msItem">
            <xsl:if test="not(@type = 'alt')">
                <em>
                    <!--<xsl:call-template name="makeLang"/>-->
                    <xsl:choose>
                        <xsl:when test="exists(@ref) and not(contains(@ref, 'pinakes'))">
                            <!--<a href="{data(@ref)}">-->
                            <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                                <xsl:apply-templates/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <a href="{data(@ref)}">
                                <xsl:apply-templates/>
                            </a>
                        </xsl:otherwise>
                    </xsl:choose>
                </em>
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
            <!--<xsl:choose>
                <xsl:when test="starts-with(@ref, 'https://www.manuscripta.se/')">
                    <a href="../{data(substring-after(@ref, 'https://www.manuscripta.se/'))}">
                        <xsl:apply-templates/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{data(@ref)}">
                        <xsl:apply-templates/>
                    </a>
                </xsl:otherwise>
            </xsl:choose>-->
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
        <xsl:choose>
            <xsl:when test="parent::ref">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>#watermark-</xsl:text>
                        <xsl:value-of select="@n"/>
                    </xsl:attribute>
                    <xsl:text>Watermark </xsl:text>
                    <xsl:value-of select="@n"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <div class="pb-2 pl-2">
                    <h6>
                        <xsl:attribute name="id">
                            <xsl:text>watermark-</xsl:text>
                            <xsl:value-of select="@n"/>
                        </xsl:attribute>
                        <xsl:text>Vattenmärke</xsl:text>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@n"/>
                    </h6>
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
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
</xsl:stylesheet>