<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml"/>

  <xsl:variable name="figure-path">http://chaucer.library.emory.edu/merton/images/</xsl:variable>
  <xsl:variable name="figure-suffix">.jpg</xsl:variable>
  <xsl:variable name="thumbnail-path">http://chaucer.library.emory.edu/merton/images/thumbnails/</xsl:variable>
  <xsl:variable name="thumbnail-suffix">.gif</xsl:variable>


  <xsl:template match="head">
    <p class="head"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="byline">
    <p class="byline"><xsl:apply-templates/></p>   
  </xsl:template>

  <xsl:template match="dateline">
    <p class="dateline"><xsl:apply-templates/></p>   
  </xsl:template>


  <!-- ignore diary dateline info for now -->
  <xsl:template match="div[@type='page']/dateline"/>

  <xsl:template match="p">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="lb">
    <br/>
  </xsl:template>

  <xsl:template match="cit">
    <p class="citation"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="lg">
    <p class="lg"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="l">
    <xsl:apply-templates/><br/>
  </xsl:template>
  
  <xsl:template match="title">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="author">
    <xsl:choose>
      <xsl:when test="@rend = 'underline'">
        <u><xsl:apply-templates/></u>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="list">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="listBibl">
    <ul class="bibl">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  
  <xsl:template match="listBibl/bibl">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="ref">
    <a>
      <xsl:attribute name="href">view.php?id=<xsl:value-of select="@target"/></xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:key name="note-by-id" match="//note" use="@id"/>

  <xsl:template match="ref[@type='inline-note']">
    <!-- apply-templates for inline note matching target id... -->
    <xsl:apply-templates select="key('note-by-id', @target)" mode="ref"/>
  </xsl:template>

  <xsl:template match="note[@place='inline']" mode="ref">
    <span class="inline-note"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="note[@place='inline']">
    <xsl:choose>
      <xsl:when test="//ref/@target = @id">
        <!-- if there is a ref targetting this note, don't display; will display via ref -->
      </xsl:when>
      <xsl:otherwise>
        <span class="inline-note"><xsl:apply-templates/></span>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>

  <xsl:template match="foreign">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="hi">
    <xsl:choose>
      <xsl:when test="@rend = 'superscript underline'">
        <span style="vertical-align:super;font-size:75%;"><u><xsl:apply-templates/></u></span>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

<xsl:template match="milestone">
  <xsl:element name="p">
    <xsl:attribute name="class">milestone</xsl:attribute>
    <xsl:choose>
      <xsl:when test="@rend='plus'">
        <xsl:text>+</xsl:text>
      </xsl:when>      
    </xsl:choose>
  </xsl:element>
</xsl:template>

<xsl:template match="figure">
  <div class="figure">
  <img>
    <xsl:attribute name="src"><xsl:value-of select="concat($figure-path, @entity, $figure-suffix)"/></xsl:attribute>
    <xsl:attribute name="alt"><xsl:value-of select="normalize-space(figDesc)"/></xsl:attribute>
    <xsl:attribute name="title"><xsl:value-of select="normalize-space(figDesc)"/></xsl:attribute>
  </img>
</div>
</xsl:template>

<xsl:template match="note">
  <hr/>
  <p class="note"><xsl:apply-templates/></p>
</xsl:template>

</xsl:stylesheet>
