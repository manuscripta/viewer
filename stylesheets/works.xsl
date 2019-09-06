<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
        <xsl:call-template name="footer"/>
    </xsl:template>

    <xsl:template match="//titleStmt/title">
        <h2 class="page-header">
            <xsl:value-of select="."/>
        </h2>
    </xsl:template>

    <xsl:template match="//bibl/title">
        <div>
            <label>Title: </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="//bibl/author/persName">
        <div>
            <label>Author: </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/editor[@role='translator']/persName">
        <div>
            <label>Translator: </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/editor[@role='editor']/persName">
        <div>
            <label>Editor: </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="//bibl/note[@type = 'incipit']">
        <div>
            <label>Incipit: </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/date">
        <div>
            <label>Dated: </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/idno[@subtype = 'geete-1']">
        <div>
            <label>Geete (text nr.): </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/idno[@subtype = 'geete-2']">
        <div>
            <label>Geete, suppl. (text nr.): </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/idno[@subtype = 'collijn']">
        <div>
            <label>Collijn, suppl. (text nr.): </label>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/note[@type = 'genre']">
        <div>
            <label>Genre: </label>
            <xsl:value-of select="title"/>
            <xsl:text> (Geete: </xsl:text>
            <xsl:value-of select="idno[@subtype='Geete']"/>
            <xsl:text> Åström: </xsl:text>
            <xsl:value-of select="idno[@subtype='Astrom']"/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/note[@type='misc']">
        <div>
            <label>Note: </label>
            <xsl:value-of select="self::node()"/>            
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/bibl">
        <div>
            <label>Referenser: </label>
            <xsl:value-of select="."/>            
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
                <a href="/work/{data(substring-after(TEI/@xml:id, 'work-'))}.xml">
                    <xsl:text>https://www.manuscripta.se/work/</xsl:text>
                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'work-'))"/>
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

    <xsl:template match="avalibility"/>

    <xsl:template match="funder"/>
    <xsl:template match="sponsor"/>
    <xsl:template match="idno"/>

    <xsl:template match="licence"/>

    <xsl:template match="publisher"/>

    <xsl:template match="respStmt"/>
    <xsl:template match="revisionDesc"/>
    <xsl:template match="sourceDesc"/>

</xsl:stylesheet>