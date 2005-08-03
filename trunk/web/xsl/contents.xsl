<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml"/>

  <xsl:include href="common.xsl"/>

  <xsl:template match="/">

    <!-- document title -->
    <xsl:apply-templates select="//titleStmt"/>

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

  <xsl:template match="titleStmt">
    <xsl:apply-templates select="title"/>, by <xsl:apply-templates select="author"/>.<br/>
    Edited by <xsl:apply-templates select="editor[position() = 1]"/>.
  </xsl:template>

  <xsl:template match="title"><i><xsl:apply-templates/></i></xsl:template>

  <xsl:template match="editor">
	<xsl:apply-templates/>  
        <xsl:if test="following::editor">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="following::editor"/>
        </xsl:if>
  </xsl:template>

  <xsl:key name="div-by-parentid" match="div[parent/@id != '']" use="parent/@id"/>

  <xsl:template match="div">
    <li><a>
    <xsl:attribute name="href">view.php?id=<xsl:value-of select="@id"/></xsl:attribute>
	<xsl:apply-templates select="head"/>
    </a>
	 <!-- <xsl:apply-templates select="@type"/> -->
    <xsl:if test="key('div-by-parentid', @id)">
      <ul>
        <xsl:apply-templates select="key('div-by-parentid', @id)"/>
      </ul>
    </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="head">
     <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
