<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exist="http://exist.sourceforge.net/NS/exist" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="tei:msItem">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:author">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::*">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="exist:match">
        <span style="color:red;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>