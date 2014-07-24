<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
        xmlns:lxslt="http://xml.apache.org/xslt"
        xmlns:string="xalan://java.lang.String">
<xsl:output method="html" indent="yes" encoding="UTF-8"
  doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />
<xsl:decimal-format decimal-separator="." grouping-separator="," />
<!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 -->

<xsl:param name="TITLE">Regression Test Results</xsl:param>

<!--

 Modified sample stylesheet to be used with Ant JUnitReport output.

 It creates a non-framed report that looks a little less like the 90's.

-->
<xsl:template match="testsuites">
    <html>
        <head>
            <title><xsl:value-of select="$TITLE"/></title>
            <link rel="stylesheet" href="colorbox.css" />
            <script src="http://code.jquery.com/jquery-1.10.2.js"></script>
            <script src="jquery.colorbox-min.js"></script>
    <style type="text/css">
      body {
        font:normal 80% verdana,arial,helvetica;
        color:#000000;
      }
      table tr td, table tr th {
          font-size: 80%;
      }
      table.details tr th{
        font-weight: bold;
        text-align:left;
        background:#a6caf0;
      }
      table.details tr td{
        background:#eeeee0;
      }

      .summary {
        border-top: solid 1px #999999;
        margin-top: 0.5em;
        padding-top: 0.5em;
        background:#fffff0;
      }

      p {
        line-height:1.5em;
        margin-top:0.5em; margin-bottom:1.0em;
      }

      a:link, a:visited{text-decoration:none; color:#416CE5; border-bottom:1px solid #416CE5;}

      .Error {
        font-weight:bold; color:red;
      }

      .Failure {
        font-weight:bold; color:purple;
      }

      .systemlog {
        font-size: 120%;
        overflow: auto;
      }

      .testsuite, .suites {
        margin: 1em;
      }

      .testsuite {
        border-top: 1px solid #333333;
      }
      </style>
      <script>
      $(document).ready(function() {
        $(".loglink").colorbox({inline:true, width:"80%"});
      })
      </script>
        </head>
        <body>
            <a name="top"></a>
            <xsl:call-template name="pageHeader"/>

            <!-- For each package create its part -->
            <xsl:call-template name="packages"/>

            <!-- For each class create the  part -->
            <xsl:call-template name="classes"/>

        </body>
    </html>
</xsl:template>

<!-- ================================================================== -->
<!-- Write a package level report                                       -->
<!-- It creates a table with values from the document:                  -->
<!-- Name | Tests | Errors | Failures | Time                            -->
<!-- ================================================================== -->
<xsl:template name="packages">
    <!-- create an anchor to this package name -->
    <xsl:for-each select="/testsuites/testsuite[not(./@package = preceding-sibling::testsuite/@package)]">
        <xsl:sort select="@package"/>

        <div class="suites">
            <table class="details" border="0" cellpadding="5" cellspacing="2">
                <xsl:call-template name="testsuite.test.header"/>

                <!-- match the testsuites of this package -->
                <xsl:apply-templates select="/testsuites/testsuite[./@package = current()/@package]" mode="print.test"/>
                <xsl:call-template name="testsuite.test.summary"/>
            </table>
        </div>
    </xsl:for-each>
</xsl:template>

<xsl:template name="classes">
    <xsl:for-each select="testsuite">
        <xsl:sort select="@name"/>
        <div class="testsuite">
            <!-- create an anchor to this class name -->
            <a name="{@name}"></a>
            <h3>Test Suite <xsl:value-of select="@name"/></h3>

            <!-- LaTeX-specific: the first test contains the full build log, so put it here. -->
            <p>
                <xsl:call-template name="log">
                    <xsl:with-param name="testcase" select="./testcase[1]"/>
                    <xsl:with-param name="title" select="'Compilation Log'" />
                    <xsl:with-param name="logid" select="generate-id()" /> <!-- Must override log ID to avoid duplication with the first test -->
                </xsl:call-template>
            </p>
            <table class="details" border="0" cellpadding="5" cellspacing="2">
              <xsl:call-template name="testcase.test.header"/>
              <xsl:apply-templates select="./testcase" mode="print.test"/>
            </table>
        </div>
    </xsl:for-each>
</xsl:template>

<xsl:template name="testsuite.test.summary">
    <xsl:variable name="testCount" select="sum(/testsuites/testsuite/@tests)"/>
    <xsl:variable name="errorCount" select="sum(/testsuites/testsuite/@errors)"/>
    <xsl:variable name="timeCount" select="sum(/testsuites/testsuite/@time)"/>
    <xsl:variable name="successRate" select="($testCount - $errorCount) div $testCount"/>
    <tr valign="top" class="summary">
        <td class="summary">
            Overall success rate:
            <xsl:call-template name="display-percent">
                <xsl:with-param name="value" select="$successRate"/>
            </xsl:call-template>
        </td>
        <td class="summary"><xsl:value-of select="$testCount"/></td>
        <td class="summary"><xsl:value-of select="$errorCount"/></td>
        <td class="summary">
            <xsl:call-template name="display-time">
                <xsl:with-param name="value" select="$timeCount"/>
            </xsl:call-template>
        </td>

    </tr>
</xsl:template>

<!-- Page HEADER -->
<xsl:template name="pageHeader">
    <h1><xsl:value-of select="$TITLE"/></h1>
</xsl:template>

<!-- class header -->
<xsl:template name="testsuite.test.header">
    <tr valign="top">
        <th>Test Suite Name</th>
        <th>Tests</th>
        <th>Failures</th>
        <th nowrap="nowrap">Time (s)</th>
    </tr>
</xsl:template>

<!-- method header -->
<xsl:template name="testcase.test.header">
    <tr valign="top">
        <th>Test Case Name</th>
        <th>Status</th>
        <th nowrap="nowrap">Time (s)</th>
    </tr>
</xsl:template>


<!-- class information -->
<xsl:template match="testsuite" mode="print.test">
    <tr valign="top">
        <!-- set a nice color depending if there is an error/failure -->
        <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="@failures[.&gt; 0]">Failure</xsl:when>
                <xsl:when test="@errors[.&gt; 0]">Error</xsl:when>
            </xsl:choose>
        </xsl:attribute>

        <!-- print testsuite information -->
        <td><a href="#{@name}"><xsl:value-of select="@name"/></a></td>
        <td><xsl:value-of select="@tests"/></td>
        <td><xsl:value-of select="@errors"/></td>
        <td>
            <xsl:call-template name="display-time">
                <xsl:with-param name="value" select="@time"/>
            </xsl:call-template>
        </td>
    </tr>
</xsl:template>

<xsl:template match="testcase" mode="print.test">
    <tr valign="top">
        <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="failure | error">Error</xsl:when>
            </xsl:choose>
        </xsl:attribute>

        <!-- Create name - link to the log if we have one -->
        <td>
            <xsl:choose>
                <xsl:when test="./system-out">
                    <xsl:call-template name="log"> <!-- Add a link to the log -->
                        <xsl:with-param name="testcase" select="."/>
                        <xsl:with-param name="title" select="@name"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </td>
        <xsl:choose>
            <xsl:when test="failure">
                <td>Failure</td>
            </xsl:when>
            <xsl:otherwise>
                <td>Success</td>
            </xsl:otherwise>
        </xsl:choose>
        <td>
            <xsl:call-template name="display-time">
                <xsl:with-param name="value" select="@time"/>
            </xsl:call-template>
        </td>
    </tr>
</xsl:template>

<!-- Make a lightbox (using Colorbox) containing system-out -->
<xsl:template name="log">
    <xsl:param name="testcase"/>
    <xsl:param name="title"/>
    <xsl:param name="logid" select="generate-id($testcase)" />

    <a href="#{$logid}" class="loglink">
        <xsl:value-of select="$title" />
    </a>
    <div style="display:none">
        <div id="{$logid}">
            <xsl:apply-templates select="$testcase/system-out" />
        </div>
    </div>
</xsl:template>

<xsl:template match="system-out">
    <div class="systemlog">
        <code>
            <pre><xsl:value-of select="." /></pre>
        </code>
    </div>
</xsl:template>

<xsl:template name="display-time">
    <xsl:param name="value"/>
    <xsl:value-of select="format-number($value,'0.000')"/>
</xsl:template>

<xsl:template name="display-percent">
    <xsl:param name="value"/>
    <xsl:value-of select="format-number($value,'0.00%')"/>
</xsl:template>

</xsl:stylesheet>
