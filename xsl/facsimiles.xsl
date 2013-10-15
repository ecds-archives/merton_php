<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
		xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:output method="xml"/>

  <xsl:include href="common.xsl"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//figure"/>
  </xsl:template>

  <xsl:template match="figure">
    <xsl:variable name="url"><xsl:value-of select="substring-before(tei:graphic/@url, '.jpg')"/></xsl:variable>
  <div class="figure">
    <a>
      <xsl:attribute name="href">view.php?id=<xsl:value-of select="$url"/></xsl:attribute>
  <img>
    <xsl:attribute name="src"><xsl:value-of select="concat($thumbnail-path, $url, $thumbnail-suffix)"/></xsl:attribute>
    <xsl:attribute name="alt"><xsl:value-of select="normalize-space(tei:figDesc)"/></xsl:attribute>
    <xsl:attribute name="title"><xsl:value-of select="normalize-space(tei:figDesc)"/></xsl:attribute>
  </img>
  <br/>
  <xsl:value-of select="parent/@id"/>
  </a>
</div>
  </xsl:template>

</xsl:stylesheet>
