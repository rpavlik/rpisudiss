<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
        xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="text" indent="no" omit-xml-declaration="yes" />
<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="xsl:text"/>

<xsl:template match="testsuites">
    <xsl:for-each select="testsuite">
        <xsl:sort select="@name"/>
        <xsl:apply-templates select="." />
    </xsl:for-each>
</xsl:template>

<xsl:template match="testsuite">
    <xsl:apply-templates select="testcase[failure]"/>
</xsl:template>

<xsl:template match="testcase">
    <xsl:text>Failure in </xsl:text>
    <xsl:value-of select="../@name"/>
    <xsl:text>: test "</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>"</xsl:text>
    <xsl:call-template name="newline"/>
</xsl:template>

<xsl:template name="newline"><xsl:text>
</xsl:text></xsl:template>
</xsl:stylesheet>
