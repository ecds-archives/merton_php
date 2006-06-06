<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xq="http://namespaces.softwareag.com/tamino/XQuery/result"
                version="1.0">

  <xsl:output method="xml"/>

  <xsl:include href="common.xsl"/>

  <xsl:template match="/">

    <ul>
      <!-- list of unique authors, languages, OR titles -->
      <xsl:apply-templates select="//xq:result/author"/>
      <xsl:apply-templates select="//xq:result/lang"/>
      <xsl:apply-templates select="//xq:result/title"/>
    </ul>

    <table>
      <xsl:apply-templates select="//xq:result/div"/>
    </table>
  </xsl:template>

  <xsl:template match="xq:result/author">
    <li><a>
    <xsl:attribute name="href">browse.php?category=author&amp;key=<xsl:value-of select="key"/></xsl:attribute>
    <xsl:apply-templates select="reg"/></a>
	  - <xsl:apply-templates select="count"/></li>
  </xsl:template>

  <xsl:template match="lang">
    <li><a>
    <xsl:attribute name="href">browse.php?category=language&amp;key=<xsl:value-of select="language/@id"/></xsl:attribute>
    <xsl:apply-templates select="language"/></a>
	 - <xsl:apply-templates select="count"/></li>
  </xsl:template>

  <xsl:template match="xq:result/title">
    <li><i><a>
    <xsl:attribute name="href">browse.php?category=title&amp;key=<xsl:value-of select="key"/></xsl:attribute>
    <xsl:apply-templates select="reg"/></a></i>  - 
    <xsl:apply-templates select="count"/></li>
  </xsl:template>

  <xsl:template match="div">
    <tr><td class='link'>
    <a><xsl:attribute name="href">view.php?id=<xsl:value-of select="@id"/></xsl:attribute>
    <xsl:apply-templates select="head[1]"/></a>
    <!-- if there is a second title, display it, but don't make it part of the link -->
    <xsl:apply-templates select="head[2]"/>
	</td>
        <td>
          <xsl:apply-templates select="cit"/>
        </td> 
   </tr>
  </xsl:template>

  <xsl:template match="cit">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
