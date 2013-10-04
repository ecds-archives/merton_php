<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:output method="xml"/>

  <xsl:include href="common.xsl"/>

  <xsl:template match="/">

    <!-- document title -->
    <xsl:apply-templates select="//tei:titleStmt"/>

    <p><b>Contents</b></p>
    <ul>
      <!-- front matter -->
      <xsl:apply-templates select="//div[parent='front']"/>
      <!-- body of the text -->
      <xsl:apply-templates select="//div[parent='body']"/>
      <!-- back matter -->
      <xsl:apply-templates select="//div[parent='back']"/>
    </ul>
  </xsl:template>

  <xsl:template match="tei:titleStmt">
    <xsl:apply-templates select="tei:title"/>, by <xsl:apply-templates select="tei:author"/>.<br/>
    Edited by <xsl:apply-templates select="tei:editor[position() = 1]"/>.
  </xsl:template>

  <xsl:template match="tei:title"><i><xsl:apply-templates/></i></xsl:template>

  <xsl:template match="tei:editor">
	<xsl:apply-templates/>  
        <xsl:if test="following::tei:editor">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="following::tei:editor"/>
        </xsl:if>
  </xsl:template>

  <xsl:key name="div-by-parentid" match="div[parent/@xml:id != '']" use="parent/@xml:id"/>

  <xsl:template match="div">
    <li><a>
    <xsl:attribute name="href">view.php?id=<xsl:value-of select="@xml:id"/></xsl:attribute>
	<xsl:apply-templates select="tei:head"/>
    </a>
	 <!-- <xsl:apply-templates select="@type"/> -->
    <xsl:if test="key('div-by-parentid', @xml:id)">
      <ul>
        <xsl:apply-templates select="key('div-by-parentid', @xml:id)"/>
      </ul>
    </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="tei:head">
     <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
