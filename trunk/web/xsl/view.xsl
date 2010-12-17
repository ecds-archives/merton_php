<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:exist="http://exist.sourceforge.net/NS/exist"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
                  version="1.0" exclude-result-prefixes="exist">

  <xsl:output method="xml"/>

  <xsl:include href="common.xsl"/>

  <xsl:template match="/">
    <xsl:apply-templates select="//exist:result"/>
  </xsl:template>

  <!-- generate next & previous links (if present) -->
  <!-- note: all divs, with id, type, and head are retrieved in a <siblings> node -->
  <xsl:template match="siblings">
    <xsl:variable name="cur_id"><xsl:value-of select="//result/tei:div/@xml:id"/></xsl:variable>

<!-- CD:  decided with ah that divs below are xml elements; thus, no tei namespace -->

    <!-- get the position of the current document in the siblings list -->
    <xsl:variable name="position">
      <xsl:for-each select="//siblings/div">
        <xsl:if test="@xml:id = $cur_id">
          <xsl:value-of select="position()"/>
        </xsl:if>
      </xsl:for-each> 
    </xsl:variable>

    <div id="next-prev">
      <xsl:apply-templates select="//siblings/div[$position - 1]">
        <xsl:with-param name="mode">prev</xsl:with-param>
      </xsl:apply-templates>
      
      <xsl:apply-templates select="//siblings/div[$position + 1]">
        <xsl:with-param name="mode">next</xsl:with-param>
      </xsl:apply-templates>
    </div>
    
  </xsl:template>

  <!-- print next/previous link with title & summary information -->
  <xsl:template match="siblings/div">
    <xsl:param name="mode"/>
    
    <xsl:variable name="linktext">
      <xsl:choose>
        <!-- 2 special cases: head is extremely long; don't display entire -->
        <xsl:when test="starts-with(tei:head, 'Bibliography')">Bibliography</xsl:when>
        <xsl:when test="starts-with(tei:head, 'Index')">Index</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="tei:head"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="a">
      <xsl:attribute name="href">view.php?id=<xsl:value-of select="@xml:id"/></xsl:attribute>
      <!-- use rel attribute to give next / previous information -->
      <xsl:attribute name="rel"><xsl:value-of select="$mode"/></xsl:attribute>
      <xsl:attribute name="class"><xsl:value-of select="$mode"/></xsl:attribute>
      <xsl:if test="$mode = 'prev'"> &lt; </xsl:if>
      <xsl:value-of select="$linktext"/>
      <xsl:if test="$mode = 'next'"> &gt; </xsl:if>
    </xsl:element> <!-- a -->   
  </xsl:template>


  <xsl:template match="siblings//tei:head">
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>
