<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0" exclude-result-prefixes="xs tei" version="3.0">
    <xsl:output indent="no" omit-xml-declaration="yes" method="text" encoding="utf-8" />
    <xsl:variable name="schemaFile" select="doc('../schemas/manuscripta.rng')"/>
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    <xsl:template match="tei:TEI">
        <xsl:variable name="repository" select="//tei:repository" />
        <xsl:variable name="msID" select="substring-after(@xml:id,'ms-')" />
        <xsl:variable name="baseURL" select="//tei:facsimile/@xml:base"/>
        <!-- variables for metadata -->
        <xsl:variable name="shelfmark" select="//tei:idno[@type = 'shelfmark']" />
        <xsl:variable name="head" select="//tei:msDesc/tei:head/normalize-space()" />
        <xsl:variable name="date" select="string-join(distinct-values(//tei:origDate), ', ')" />
        <xsl:variable name="support1" select="string-join(distinct-values(//tei:supportDesc/@material), ', ')"/> 
        <xsl:variable name="support" select="concat(upper-case(substring($support1,1,1)), substring($support1,2))"/>
        <xsl:variable name="textLang">
            <xsl:variable name="textlangValue" select="//tei:msContents/tei:textLang/@mainLang"/>
            <xsl:variable name="schemaTextlanguages" select="$schemaFile//rng:define[@name='textLang']//rng:attribute[@name='mainLang']/rng:choice"/>
            <xsl:for-each select="$schemaTextlanguages/rng:value">
                <xsl:choose>
                    <xsl:when test=". = $textlangValue">
                        <xsl:value-of select="substring-after(substring-before(following-sibling::a:documentation[1], ')'), '(')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//tei:msContents/tei:textLang/@mainLang"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="leftFlyleaves" select="//tei:measure[@type='leftFlyleaves']/@quantity"/>
        <xsl:variable name="rightFlyleaves" select="//tei:measure[@type='rightFlyleaves']/@quantity"/>
        <xsl:variable name="textblockLeaves" select="//tei:measure[@type='textblockLeaves']/@quantity"/>
        <xsl:variable name="extent">
            <xsl:if test="$leftFlyleaves != '0'">
                <xsl:value-of select="format-integer($leftFlyleaves, 'i')"/>
            <xsl:text>, </xsl:text>
            </xsl:if>
            <!-- Sum of extent for all msParts -->
            <xsl:value-of select="sum($textblockLeaves)"/>
            <xsl:if test="$rightFlyleaves != '0'">
                <xsl:text>, </xsl:text>
            <xsl:value-of select="format-integer($rightFlyleaves, 'i')"/>
                <xsl:text>´</xsl:text>
            </xsl:if>
            <xsl:text> ff.</xsl:text>
        </xsl:variable>
        <!-- variables for description -->
        <xsl:variable name="summary" select="//tei:summary" />
        <xsl:variable name="collation" select="//tei:collation/tei:p" />
        <xsl:variable name="layout" select="//tei:layout" />
        <xsl:variable name="scriptNote" select="//tei:scriptNote" />
        <xsl:variable name="decoNote" select="//tei:decoDesc/tei:decoNote[1]" />
        <xsl:variable name="binding" select="//tei:binding/tei:p" />
        <xsl:variable name="description" select="//tei:msDesc/tei:head/normalize-space()" />
        <xsl:variable name="first-folio" select="//tei:facsimile/(tei:surface[matches(@xml:id, '^ms-\d{6}(_\d{4})?_\dr?$')][1] | tei:surface[matches(@xml:id, '^ms-\d{6}(_\d{4})?_S?\dr?$')][1] | tei:surface[1])[last()]/tei:graphic/@url" />
        <xsl:variable name="first-folio-id" select="translate($first-folio, '.tif', '')" />
        <xsl:variable name="start-canvas" select="count(//tei:surface[following-sibling::tei:surface/tei:graphic[@url = $first-folio]])"/>
        <xsl:if test="exists(//tei:facsimile)"><xsl:result-document href="{concat('../../../../iiif/temp/',$msID,'/manifest.json')}">{
    "@context": "http://iiif.io/api/presentation/2/context.json",
    "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID" />/manifest.json",
    "@type": "sc:Manifest",
    "label": "<xsl:value-of select="$repository" />, <xsl:value-of select="$shelfmark" />",
    "metadata": [
        {
            "label": "Repository",
            "value": "<xsl:value-of select="$repository" />"
        },
        {
            "label": "Shelfmark",
            "value": "<xsl:value-of select="$shelfmark" />"
        },
        {
            "label": "Title",
            "value": "<xsl:value-of select="$head" />"
        },
        {
            "label": "Date",
            "value": "<xsl:value-of select="$date" />"
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
            "value": "<xsl:value-of select="$textLang" />"
        }
    ],
    "description": "<xsl:value-of select="$description" />",
    "thumbnail": {
        "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID" />/canvas/c-<xsl:value-of select="$start-canvas + 1"/>.json",
        "service": {
            "@context": "http://iiif.io/api/image/2/context.json",
            "@id": "<xsl:value-of select="$baseURL" /><xsl:value-of select="$msID" />/<xsl:value-of select="$first-folio" />",
            "profile": "http://iiif.io/api/image/2/level1.json"
        }
    },
    "viewingHint": "paged",
    "license": "http://creativecommons.org/publicdomain/zero/1.0/",
    "attribution": "<xsl:value-of select="$repository" />",
    "seeAlso": {
        "@id": "https://www.manuscripta.se/ms/<xsl:value-of select="$msID" />.xml",
        "format": "application/tei+xml"
    },
    "related": {
        "@id": "https://www.manuscripta.se/ms/<xsl:value-of select="$msID" />",
        "format": "text/html"
    },
    "sequences": [
        {
            "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID" />/sequence/s-1.json",
            "@type": "sc:Sequence",
            "label": "Current order",<!--"rendering": {                "@id": "https://www.manuscripta.se/pdf/ms-<xsl:value-of select="$msID" />.pdf", "format": "application/pdf", "label": "Download as PDF" },  -->
            "startCanvas": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID" />/canvas/c-<xsl:value-of select="$start-canvas + 1"/>.json",
            "canvases": [<xsl:for-each select="//tei:surface"><!-- canvas and resource variables -->
                <xsl:variable name="label" select="tei:desc" />
                <xsl:variable name="height" select="translate(tei:graphic/@height, 'px', '')" />
                <xsl:variable name="width" select="translate(tei:graphic/@width, 'px', '')" />
                <xsl:variable name="image" select="tei:graphic/@url" />
                <xsl:variable name="folio-id" select="substring-before($image, '.tif')" />
                <xsl:variable name="count-number" select="position()" />
                {
                    "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID" />/canvas/c-<xsl:value-of select="$count-number" />.json",
                    "@type": "sc:Canvas",
                    "label": "<xsl:value-of select="$label" />",
                    "height": <xsl:value-of select="$height" />,
                    "width": <xsl:value-of select="$width" />,
                    "thumbnail": {
                        "@id": "<xsl:value-of select="$baseURL" /><xsl:value-of select="$msID" />/<xsl:value-of select="$image" />/full/90,/0/default.jpg",
                        "service": {
                            "@context": "http://iiif.io/api/image/2/context.json",
                            "@id": "<xsl:value-of select="$baseURL" /><xsl:value-of select="$msID" />/<xsl:value-of select="$image" />",
                            "profile": "http://iiif.io/api/image/2/level1.json"
                        }
                    },
                    "images": [
                        {
                            "@id": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID" />/annotation/<xsl:value-of select="$folio-id" />.json",
                            "@type": "oa:Annotation",
                            "motivation": "sc:painting",
                            "on": "https://www.manuscripta.se/iiif/<xsl:value-of select="$msID" />/canvas/c-<xsl:value-of select="$count-number" />.json",
                            "resource": {
                                "@id": "<xsl:value-of select="$baseURL" /><xsl:value-of select="$msID" />/<xsl:value-of select="$image" />/full/full/0/default.jpg",
                                "@type": "dctypes:Image",
                                "format": "image/jpeg",
                                "height": <xsl:value-of select="$height" />,
                                "width": <xsl:value-of select="$width" />,
                                "service": {
                                    "@context": "http://iiif.io/api/image/2/context.json",
                                    "@id": "<xsl:value-of select="$baseURL" /><xsl:value-of select="$msID" />/<xsl:value-of select="$image" />",
                                    "profile": "http://iiif.io/api/image/2/level1.json"
                                }
                            }
                        }
                    ]
                }<xsl:choose><xsl:when test="position() != last()">,</xsl:when>
<xsl:otherwise>
            ]
        }
    ]
}</xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:result-document>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
