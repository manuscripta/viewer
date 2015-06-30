<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

    <xsl:output method="html" version="5.0" indent="yes" encoding="utf-8"/>

    <xsl:include href="templates.xsl"/>

    <xsl:template match="/">

        <main class="panel-group" id="msDescription" role="main">

            <xsl:apply-templates select="//revisionDesc"/>

            <section class="summary">

                <div class="page-header">
                    <h1>
                        <xsl:attribute name="id">
                            <xsl:value-of select="/TEI/@xml:id"/>
                        </xsl:attribute>
                        <xsl:value-of select="//repository, //msDesc/msIdentifier/idno" separator=", "/>
                        <!--<xsl:if test="count(//msPart) gt 1">
                        (<xsl:value-of select="count(//msPart)" /> units)
                        </xsl:if>-->
                        <!--<xsl:if test="//idno[@type='former_shelfmark']">
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="//idno[@type='former_shelfmark']" />
                            <xsl:text>)</xsl:text>
                        </xsl:if>-->
                    </h1>
                </div>

                <h2>
                    <xsl:value-of select="//msDesc/head"/>
                </h2>

                <p>
                    <xsl:if test="exists(//origPlace)">
                        <xsl:value-of select="normalize-space(//msDesc/history/origin//origPlace)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:if test="exists(//origin/@notBefore)">
                        <xsl:value-of select="//origin/@notBefore"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="//origin/@notAfter"/>
                    </xsl:if>
                    <xsl:if test="exists(//origDate)">
                        <xsl:apply-templates select="//origDate"/>
                    </xsl:if>
                </p>
                <p>
                    <xsl:value-of select=" distinct-values(//supportDesc/@material)"/>
                </p>
                <p>
                    <xsl:text> ff. </xsl:text>
                    <xsl:if test="//measure[@type='left_flyleaves' and @quantity ge '1']">
                        <xsl:number format="i" value="//measure[@type='left_flyleaves']/@quantity"/>
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="sum(//measure[@type='textblock_leaves']/@quantity)"/>
                    <xsl:if test="//measure[@type='right_flyleaves' and @quantity ge '1']">
                        <xsl:text>, </xsl:text>
                        <xsl:number format="i" value="//measure[@type='right_flyleaves']/@quantity"/>
                        <xsl:text>'</xsl:text>
                    </xsl:if>
                </p>
                <p>
                    <xsl:value-of select="distinct-values(//support//dimensions[@type='leaf']/height/@quantity)"/>
                    <xsl:text> × </xsl:text>
                    <xsl:value-of select="distinct-values(//support//dimensions[@type='leaf']/width/@quantity)"/>
                    <xsl:text> mm</xsl:text>
                </p>
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
                        <xsl:apply-templates select="//msDesc/msContents"/>
                        <xsl:for-each select="//msPart">                            
                            <xsl:if test="count(//msPart) gt 1">
                                <h4>Unit <xsl:value-of select="msIdentifier/idno[@type='codicological_unit']/text()"/>
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
                        <h4>Foliation</h4>
                        <xsl:for-each select="//foliation">
                            <xsl:choose>
                                <xsl:when test="ancestor::msPart">
                                    <p>
                                        <xsl:if test="count(//msPart) gt 1">
                                            <span class="unit_nr">Unit <xsl:number count="msPart" format="I"/>: </span>
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


                        <div class="collation">
                            <h4>Collation</h4>
                            <p>
                                <xsl:for-each select="//msPart">
                                    <xsl:if test="position() != last()">
                                        <xsl:apply-templates select="physDesc//collation/formula"/>
                                        <xsl:text>| </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="position() = last()">
                                        <xsl:apply-templates select="physDesc//collation/formula"/>
                                        <xsl:apply-templates select="//collation/p"/>
                                    </xsl:if>
                                </xsl:for-each>
                            </p>
                            <!--<div class="signatures">
                            <h4>Signatures: </h4>
                            <xsl:for-each select="//msPart">
                                <xsl:choose>
                                    <xsl:when test="//signatures[contains(.,'none')]">
                                        <xsl:choose>
                                            <xsl:when test="following-sibling::msPart[//signatures[not(contains(.,'none'))]]">
                                                <p>
                                                    <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                                                    TEST
                                                </p>
                                            </xsl:when>
                                        </xsl:choose>

                                    </xsl:when>
                                    <xsl:otherwise>
                                        <p>
                                            <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                                            <xsl:apply-templates select="." />
                                        </p>
                                    </xsl:otherwise>

                                </xsl:choose>
                            </xsl:for-each>
                        </div>
                        <div class="catchwords">
                            <h4>Catchwords: </h4>
                            <xsl:for-each select="//catchwords">
                                <p>
                                    <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />: </span>
                                    <xsl:apply-templates select="." />
                                </p>
                            </xsl:for-each>
                        </div>-->
                        </div>

                        <div class="support">
                            <h4>Support</h4>
                            <!--<xsl:for-each select="//supportDesc/support">
                            <p>
                                <xsl:if test="count(//msPart) gt 1">
                                    <span class="unit_nr">Unit <xsl:number count="msPart" format="I" />:</span>
                                </xsl:if>
                                <xsl:apply-templates select="." />
                            </p>
                        </xsl:for-each>-->
                            <xsl:for-each select="//support">
                                <xsl:choose>
                                    <xsl:when test="ancestor::msPart">
                                        <xsl:if test="count(//msPart) gt 1">
                                            <span class="unit_nr">Unit <xsl:number count="msPart" format="I"/>: </span>
                                        </xsl:if>
                                        <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="unit_nr">Bookblock: </span>
                                        <xsl:apply-templates/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </div>

                        <h4>Script</h4>
                        <xsl:for-each select="//handDesc">
                            <xsl:choose>
                                <xsl:when test="ancestor::msPart">
                                    <p>
                                        <xsl:if test="count(//msPart) gt 1">
                                            <span class="unit_nr">Unit <xsl:number count="msPart" format="I"/>: </span>
                                        </xsl:if>
                                        <xsl:apply-templates select="handNote"/>
                                    </p>
                                </xsl:when>
                                <xsl:otherwise>
                                    <p>
                                        <span class="unit_nr">Book: </span>
                                        <xsl:apply-templates select="handNote"/>
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>

                        <h4>Layout</h4>
                        <xsl:for-each select="//layoutDesc">
                            <xsl:apply-templates/>
                        </xsl:for-each>


                        <h4>Binding</h4>
                        <xsl:apply-templates select="//bindingDesc"/>

                        <!--<div class="handDesc">
                            <h4>Script: </h4>
                            <xsl:for-each select="//handDesc">
                                <xsl:apply-templates select="handNote" />
                            </xsl:for-each>
                        </div>
                        <div class="layoutDesc">
                            <h4>Layout: </h4>
                            <xsl:for-each select="layoutDesc">
                                <xsl:apply-templates select="." />
                            </xsl:for-each>
                        </div>
                        <div class="decoDesc">
                            <h4>Decoration: </h4>
                            <xsl:apply-templates select="//decoDesc" />
                        </div>-->
                        <!--</xsl:for-each>-->
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
                    </div>
                </div>
            </section>

            <!--<xsl:if test="exists(//text)">
                <section class="text">
                    <h3>Texts</h3>
                    <xsl:apply-templates select="//text" />
                </section>
            </xsl:if>-->

            <div class="lastRevision">
                <xsl:apply-templates select="//change"/>
            </div>
        </main>

    </xsl:template>

</xsl:stylesheet>