<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml"/>

  <xsl:include href="common.xsl"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//figure"/>
  </xsl:template>

  <xsl:template match="figure">
  <div class="figure">
    <a>
      <xsl:attribute name="href">view.php?id=<xsl:value-of select="@entity"/></xsl:attribute>
  <img>
    <xsl:attribute name="src"><xsl:value-of select="concat($thumbnail-path, @entity, $thumbnail-suffix)"/></xsl:attribute>
    <xsl:attribute name="alt"><xsl:value-of select="normalize-space(figDesc)"/></xsl:attribute>
    <xsl:attribute name="title"><xsl:value-of select="normalize-space(figDesc)"/></xsl:attribute>
  </img>
  <br/>
  <xsl:value-of select="parent/@id"/>
  </a>
</div>
  </xsl:template>

</xsl:stylesheet>
