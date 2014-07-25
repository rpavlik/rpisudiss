<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
        xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />
<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="xsl:text"/>

<xsl:param name="fullwidthline"
    select="'-----------------------------------------------------------------------'"/>
<xsl:param name="linewidth"
    select="string-length($fullwidthline)"/>

<xsl:template match="testsuites">
    <xsl:for-each select="testsuite">
        <xsl:sort select="@name"/>
        <xsl:apply-templates select="." />
    </xsl:for-each>
</xsl:template>

<xsl:template match="testsuite">
    <xsl:call-template name="newline"/>
    <xsl:text>Suite: </xsl:text><xsl:value-of select="@name" /><xsl:call-template name="newline"/>
    <xsl:call-template name="hr"/>    
    
    <xsl:apply-templates select="testcase"/>
</xsl:template>

<xsl:template match="testcase">
    
    <xsl:call-template name="twocolumn">
        <xsl:with-param name="first">
            <xsl:text>- </xsl:text><xsl:value-of select="@name"/><xsl:text>:</xsl:text>
        </xsl:with-param>
        
        <xsl:with-param name="second">
            <xsl:choose>
                <xsl:when test="failure">
                    <xsl:text>Failed</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Passed</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template name="twocolumn">
    <xsl:param name="first" />
    <xsl:param name="second" />
    
    <xsl:param name="padding" select="xs:integer($linewidth - string-length($first) - string-length($second))" />
    
    <xsl:value-of select="$first" />
    <xsl:for-each select="1 to $padding">
       <xsl:value-of select="' '"/>
    </xsl:for-each>
    <xsl:value-of select="$second" />
    <xsl:call-template name="newline"/>
</xsl:template>

<xsl:template name="hr">
    <xsl:value-of select="$fullwidthline" />
    <xsl:call-template name="newline"/>
</xsl:template>

<xsl:template name="newline"><xsl:text>
</xsl:text></xsl:template>

</xsl:stylesheet>
