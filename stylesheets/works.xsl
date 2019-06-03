<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xhtml" indent="yes" encoding="utf-8"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
        <xsl:call-template name="footer"/>
    </xsl:template>

    <xsl:template match="//titleStmt/title">
        <h3 class="page-header">
            <xsl:value-of select="."/>
        </h3>
    </xsl:template>

    <xsl:template match="//bibl/title">
        <div>
            <span class="head">Title: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="//bibl/author/persName">
        <div>
            <span class="head">Author: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/editor[@role='translator']/persName">
        <div>
            <span class="head">Translator: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/editor[@role='editor']/persName">
        <div>
            <span class="head">Editor: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <xsl:template match="//bibl/note[@type = 'incipit']">
        <div>
            <span class="head">Incipit: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/date">
        <div>
            <span class="head">Dated: </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/idno[@subtype = 'geete-1']">
        <div>
            <span class="head">Geete (text nr.): </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/idno[@subtype = 'geete-2']">
        <div>
            <span class="head">Geete, suppl. (text nr.): </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/idno[@subtype = 'collijn']">
        <div>
            <span class="head">Collijn, suppl. (text nr.): </span>
            <xsl:value-of select="."/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/note[@type = 'genre']">
        <div>
            <span class="head">Genre: </span>
            <xsl:value-of select="title"/>
            <xsl:text> (Geete: </xsl:text>
            <xsl:value-of select="idno[@subtype='Geete']"/>
            <xsl:text> Åström: </xsl:text>
            <xsl:value-of select="idno[@subtype='Astrom']"/>
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/note[@type='misc']">
        <div>
            <span class="head">Note: </span>
            <xsl:value-of select="self::node()"/>            
        </div>
    </xsl:template>
    
    <xsl:template match="//bibl/bibl">
        <div>
            <span class="head">Referenser: </span>
            <xsl:value-of select="."/>            
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
                <a href="/work/{data(substring-after(TEI/@xml:id, 'work-'))}.xml">
                    <xsl:text>https://www.manuscripta.se/work/</xsl:text>
                    <xsl:value-of select="data(substring-after(TEI/@xml:id, 'work-'))"/>
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