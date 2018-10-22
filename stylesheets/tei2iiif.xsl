<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="3.0">

    <xsl:output indent="no" omit-xml-declaration="yes" method="text" encoding="utf-8"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:TEI">
        <xsl:variable name="repository" select="//tei:repository"/>
        <xsl:variable name="msID" select="substring-after(@xml:id,'ms-')"/>
        <!-- variables for metadata -->
        <xsl:variable name="shelfmark" select="//tei:idno[@type = 'shelfmark']"/>
        <xsl:variable name="head" select="//tei:msDesc/tei:head"/>
        <xsl:variable name="date" select="//tei:origDate"/>
        <xsl:variable name="support" select="//tei:supportDesc/@material"/>
        <xsl:variable name="textLang" select="//tei:msContents/tei:textLang/@mainLang"/>
        <xsl:variable name="extent">
            <xsl:value-of select="format-integer(//tei:measure[@type='leftFlyleaves']/@quantity, 'i')"/>
            <xsl:text>, </xsl:text>            
            <xsl:value-of select="//tei:measure[@type='textblockLeaves']/@quantity"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="format-integer(//tei:measure[@type='rightFlyleaves']/@quantity, 'i')"/>
        </xsl:variable>
        <!-- variables for description -->
        <xsl:variable name="summary" select="//tei:summary"/>
        <xsl:variable name="collation" select="//tei:collation/tei:p"/>
        <xsl:variable name="layout" select="//tei:layout"/>
        <xsl:variable name="scriptNote" select="//tei:scriptNote"/>
        <xsl:variable name="decoNote" select="//tei:decoDesc/tei:decoNote[1]"/>
        <xsl:variable name="binding" select="//tei:binding/tei:p"/>
        <xsl:variable name="description" select="//tei:msDesc/tei:head"/>
        
        <!-- Cover Thumbnail -->
        <xsl:variable name="cover-thumb" select="//tei:facsimile/tei:surface[1]/tei:graphic/@url"/>        
        <xsl:variable name="folio-id" select="translate($cover-thumb, '.tif', '')"/>
        <xsl:variable name="first-folio" select="//tei:facsimile/tei:surface/tei:graphic/@url[ends-with(., '_001r.tif')]"/>
        <xsl:variable name="start-canvas" select="count(//tei:surface[following::tei:surface[tei:graphic/@url[ends-with(., '_001r.tif')]]])"/>
        <xsl:if test="exists(//tei:facsimile)">{
    "@context": "http://iiif.io/api/presentation/2/context.json",
    "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID"/>/manifest.json",
    "@type": "sc:Manifest",
    "label": "<xsl:value-of select="$repository"/>, <xsl:value-of select="$shelfmark"/>",    
    "metadata": [
        {
            "label": "Repository",
            "value": "<xsl:value-of select="$repository"/>"
        },
        {
            "label": "Shelfmark",
            "value": "<xsl:value-of select="$shelfmark"/>"
        },
        {
            "label": "Title",
            "value": "<xsl:value-of select="$head"/>"
        },
        {
            "label": "Date",
            "value": "<xsl:value-of select="$date"/>"
        },
        {
            "label": "Support",
            "value": "<xsl:value-of select="$support"/>"            
        },
        {
            "label": "Extent",
            "value": "<xsl:value-of select="$extent"/>"            
        },
        {
            "label": "Language",
            "value": "<xsl:value-of select="$textLang"/>"
        }
    ],
    "description": "<xsl:value-of select="$description"/>",
    "thumbnail": 
        {
            "@id": "https://www.manuscripta.se/iipsrv/iipsrv.fcgi?IIIF=<xsl:value-of select="$msID"/>/<xsl:value-of select="$first-folio"/>/full/90,/0/default.jpg",
            "service": {
                "@context": "http://iiif.io/api/image/2/context.json",
                "@id": "https://www.manuscripta.se/iipsrv/iipsrv.fcgi?IIIF=<xsl:value-of select="$msID"/>/<xsl:value-of select="$first-folio"/>",
                "profile": "http://iiif.io/api/image/2/level1.json"
            }
        },    
    "viewingHint": "paged",
    "license": "http://creativecommons.org/publicdomain/zero/1.0/",
    "attribution": "<xsl:value-of select="$repository"/>",
    "seeAlso": 
        {
            "@id": "https://www.manuscripta.se/xml/<xsl:value-of select="$msID"/>",
            "format": "application/tei+xml"
        },
    "related": {
        "@id": "https://www.manuscripta.se/ms/<xsl:value-of select="$msID"/>",
        "format": "text/html"
    },           
    "sequences": [
        {
            "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID"/>/sequence/s-1.json",
            "@type": "sc:Sequence",
            "label": "Current order",
            "rendering": {
                "@id": "https://www.manuscripta.se/pdf/<xsl:value-of select="$msID"/>.pdf",
                "format": "application/pdf",
                "label": "Download as PDF"
            },        
        "startCanvas": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID"/>/canvas/c-<xsl:value-of select="$start-canvas + 1"/>.json",
        "canvases": [
            <xsl:for-each select="//tei:surface">
                <!-- canvas and resource variables -->
                <xsl:variable name="label" select="tei:desc"/>
                <xsl:variable name="height" select="translate(tei:graphic/@height, 'px', '')"/>
                <xsl:variable name="width" select="translate(tei:graphic/@width, 'px', '')"/>
                <xsl:variable name="image" select="tei:graphic/@url"/>
                <xsl:variable name="folio-id" select="substring-before($image, '.tif')"/>
                <xsl:variable name="count-number" select="position()"/>                
            {
                "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID"/>/canvas/c-<xsl:value-of select="$count-number"/>.json",
                "@type": "sc:Canvas",
                "label": "<xsl:value-of select="$label"/>",
                "height": <xsl:value-of select="$height"/>,
                "width": <xsl:value-of select="$width"/>,
                "thumbnail": 
                    {
                        "@id": "https://www.manuscripta.se/iipsrv/iipsrv.fcgi?IIIF=<xsl:value-of select="$msID"/>/<xsl:value-of select="$image"/>/full/90,/0/default.jpg",
                        "service": {
                            "@context": "http://iiif.io/api/image/2/context.json",
                            "@id": "https://www.manuscripta.se/iipsrv/iipsrv.fcgi?IIIF=<xsl:value-of select="$msID"/>/<xsl:value-of select="$image"/>",
                            "profile": "http://iiif.io/api/image/2/level1.json"
                        }
                    },                
                "images": [
                    {
                        "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID"/>/annotation/<xsl:value-of select="$folio-id"/>.json",
                        "@type": "oa:Annotation",
                        "motivation": "sc:painting",
                        "on": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID"/>/canvas/c-<xsl:value-of select="$count-number"/>.json",
                        "resource": {
                            "@id": "https://www.manuscripta.se/iipsrv/iipsrv.fcgi?IIIF=<xsl:value-of select="$msID"/>/<xsl:value-of select="$image"/>/full/full/0/default.jpg",
                            "@type": "dctypes:Image",
                            "format": "image/jpeg",
                            "height": <xsl:value-of select="$height"/>,
                            "width": <xsl:value-of select="$width"/>,
                            "service": {
                                "@context": "http://iiif.io/api/image/2/context.json",
                                "@id": "https://www.manuscripta.se/iipsrv/iipsrv.fcgi?IIIF=<xsl:value-of select="$msID"/>/<xsl:value-of select="$image"/>",
                                "profile": "http://iiif.io/api/image/2/level1.json"
                            }
                        }
                    }
                ]
            }<xsl:choose>
                    <xsl:when test="position() != last()">,</xsl:when>
<xsl:otherwise>
        ]
    }]
}
</xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>