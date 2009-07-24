<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exist="http://exist.sourceforge.net/NS/exist"
                  version="1.0" exclude-result-prefixes="exist">

  <xsl:output method="xml"/>
  <xsl:include href="common.xsl"/>

  <xsl:param name="keyword"/>
  <xsl:variable name="total"><xsl:value-of select="//@exist:hits"/></xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="total"/>
    <xsl:apply-templates select="//exist:result//div"/>
  </xsl:template>

  <xsl:template name="total">
    <xsl:element name="p">
      <xsl:value-of select="$total"/> match<xsl:if test="$total != 1">es</xsl:if> found
    </xsl:element>
  </xsl:template>

  <xsl:template match="div">
    <p>
      <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
      <a>
        <xsl:attribute name="href">view.php?id=<xsl:value-of select="@id"/><xsl:if test="$keyword">&amp;keyword=<xsl:value-of select="$keyword"/></xsl:if></xsl:attribute>
        <xsl:apply-templates select="head"/>
      </a>
        (<xsl:value-of select="@type"/>)
      <xsl:apply-templates select="matches"/>
    </p>
  </xsl:template>

  <xsl:template match="matches">
    <br/>
    <xsl:apply-templates select="total"/> match<xsl:if test="total > 1">es</xsl:if>
      <!-- only display counts for each term if there is more than one term -->
    <xsl:if test="count(term) > 1">
      <xsl:apply-templates select="term"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="term">
    <span class="term"><xsl:value-of select="text()"/> : <xsl:value-of select="count"/></span>
  </xsl:template>

  <xsl:template match="head">
    <b><xsl:apply-templates/></b>
  </xsl:template>


</xsl:stylesheet>
