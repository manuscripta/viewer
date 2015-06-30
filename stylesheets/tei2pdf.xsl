<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns:s="http://syriaca.org" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://syriaca.org/ns" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs t s saxon" version="2.0">
    <xsl:attribute-set name="h1">
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="border-after-width">1pt</xsl:attribute>
        <xsl:attribute name="border-after-style">solid</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="h2">
        <xsl:attribute name="margin-top">18pt</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="h3">
        <xsl:attribute name="margin-top">8pt</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="border-after-width">1pt</xsl:attribute>
        <xsl:attribute name="border-after-style">dotted</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="h4">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="href">
        <xsl:attribute name="color">blue</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="bold">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="italic">
        <xsl:attribute name="font-variation">italic</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="p">
        <xsl:attribute name="margin-top">8pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="caveat">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="def-list">
        <xsl:attribute name="margin-left">12pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="def-list">
        <xsl:attribute name="margin-top">8pt</xsl:attribute>
        <xsl:attribute name="margin-right">8pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
        <xsl:attribute name="margin-left">8pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section">
        <xsl:attribute name="margin-left">8pt</xsl:attribute>
        <xsl:attribute name="margin-top">8pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:variable name="pageHeader">
        <xsl:call-template name="title"/>
    </xsl:variable>
    <xsl:template match="/">
        <fo:root font-family="verdana, arial, sans-serif" font-size="10pt">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="contents" page-width="8.5in" page-height="11in" margin-top="0.25in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
                    <fo:region-body margin="0.5in" margin-bottom="1in"/>
                    <fo:region-before extent="0.75in"/>
                    <fo:region-after extent="0.2in"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="contents">
                <fo:static-content flow-name="xsl-region-before" margin-top=".25in">
                    <fo:block color="gray" text-align="center">
                        <xsl:value-of select="$pageHeader"/>
                    </fo:block>
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block padding-top=".025in" margin-bottom="0in" padding-after="0in" padding-bottom="0">
                        <fo:block color="gray" padding-top="0in" margin-top="-0.015in" border-top-style="solid" border-top-color="#333" border-top-width=".015in">
                            <fo:table space-before="0.07in" table-layout="fixed" width="100%" font-size="8pt" margin-top=".05in" padding-top="0in">
                                <fo:table-column column-width="5in"/>
                                <fo:table-column column-width="2in"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block text-align="left" margin-left=".025in">
                                                <fo:retrieve-marker retrieve-class-name="title"/>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block text-align="right" margin-right="-.475in">
                                                <xsl:text> Page </xsl:text>
                                                <fo:page-number/>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:apply-templates/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    <xsl:template name="title">
        <xsl:value-of select="//tei:titleStmt/tei:title/text()"/>
    </xsl:template>
    <xsl:template match="tei:teiHeader">
        <fo:block>
            <fo:block xsl:use-attribute-sets="h1" border-bottom="1px">
                <xsl:call-template name="title"/>
            </fo:block>
            <!--<fo:block>
                <fo:block xsl:use-attribute-sets="h4">Folger Shakespeare Library</fo:block>
                <fo:block xsl:use-attribute-sets="p">
                    <fo:basic-link external-destination="url('http://www.folgerdigitaltexts.org')" xsl:use-attribute-sets="href">http://www.folgerdigitaltexts.org</fo:basic-link>
                </fo:block>
            </fo:block>
            <fo:block xsl:use-attribute-sets="h3">Characters in the Play</fo:block>-->
            <fo:block xsl:use-attribute-sets="section">
                <fo:block xsl:use-attribute-sets="p">
                    <xsl:apply-templates select="//tei:profileDesc/tei:particDesc" mode="list-char"/>
                </fo:block>
            </fo:block>
        </fo:block>
    </xsl:template>
    <xsl:template match="tei:listPerson" mode="list-char">
        <fo:block>
            <xsl:choose>
                <xsl:when test="tei:head">
                    <xsl:apply-templates select="tei:head"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="tei:person" mode="list-char"/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>
    <xsl:template mode="list-char" match="tei:person">
        <fo:block>
            <fo:inline xsl:use-attribute-sets="bold">
                <xsl:apply-templates select="tei:persName" mode="list-char"/>
            </fo:inline>,
            <xsl:apply-templates select="tei:state/tei:p/text()"/>
            <xsl:apply-templates select="tei:sex"/>
        </fo:block>
    </xsl:template>
    <xsl:template match="tei:persName | tei:name" mode="list-char">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:p">
        <fo:block xsl:use-attribute-sets="p">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="tei:person/tei:sex">
        <fo:inline>
            <xsl:text> [</xsl:text>
            <xsl:value-of select="."/>]</fo:inline>
    </xsl:template>
    <xsl:template match="tei:lb">
        <fo:block/>
    </xsl:template>
    <xsl:template match="tei:pb">
        <fo:block font-size="8pt" border-before-width="1pt" border-before-style="solid" margin-bottom="16pt" margin-top="8pt">
            <xsl:value-of select="@n"/>
            <xsl:text>&#160;&#160;&#160;</xsl:text>
            <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
            <xsl:text>&#160;&#160;&#160;</xsl:text>
            <fo:inline font-variant="italic">
                (<xsl:value-of select="following-sibling::tei:fw"/>)
            </fo:inline>
        </fo:block>
    </xsl:template>
    <xsl:template match="tei:text/tei:body/tei:pb"/>
    <xsl:template match="tei:div1">
        <fo:block margin-top="18pt">
            <xsl:apply-templates/>
        </fo:block>
        <hr/>
    </xsl:template>
    <xsl:template match="tei:div1/tei:head">
        <fo:block xsl:use-attribute-sets="h2">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="tei:div2">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="tei:div2/tei:head">
        <fo:block xsl:use-attribute-sets="h4">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    <xsl:template match="tei:head">
        <xsl:choose>
            <xsl:when test="@rend='inline'">
                <fo:inline font-variant="italic">
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:when>
            <xsl:otherwise>
                <fo:block font-variant="italic">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:speaker">
        <fo:inline font-variant="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    <xsl:template match="tei:w|tei:c|tei:pc|tei:w/tei:seg|tei:anchor" xml:space="preserve">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:stage">
        <fo:inline font-variant="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
</xsl:stylesheet>