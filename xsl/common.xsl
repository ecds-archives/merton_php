<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml"/>

  <xsl:variable name="figure-path">http://beck.library.emory.edu/merton/image-content/</xsl:variable>
  <xsl:variable name="figure-suffix">.jpg</xsl:variable>
  <xsl:variable name="thumbnail-path">http://beck.library.emory.edu/merton/image-content/thumbnails/</xsl:variable>
  <xsl:variable name="thumbnail-suffix">.gif</xsl:variable>


  <xsl:template match="div">
    <div>
      <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
      <xsl:apply-templates/>
    </div>    
  </xsl:template>

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
    <div class="citation"><xsl:apply-templates/></div>
  </xsl:template>

  <!-- keep note citations within note paragraph -->
  <xsl:template match="note/cit">
    <br/><span class="citation"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="quote">
    <div class="quote"><xsl:apply-templates/></div>
  </xsl:template>

  <xsl:template match="bibl[not(ancestor::note)]">
    <p class='bibl'>
      <xsl:apply-templates/>
    </p>
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
    <xsl:choose>
      <xsl:when test="ancestor::div//note/@id=./@target">
        <!-- if the ref refers to a note in this section but is NOT inline,
             don't create a link -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <a><xsl:attribute name="href">view.php?id=<xsl:value-of select="@target"/></xsl:attribute>
          <xsl:apply-templates/></a>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:key name="note-by-id" match="//note" use="@id"/>

  <xsl:template match="ref[@type='inline-note']">
    <!-- apply-templates for inline note matching target id... -->
    <xsl:apply-templates select="key('note-by-id', @target)" mode="ref"/>
  </xsl:template>

  <xsl:template match="note[@place='inline']" mode="ref">
    <span>
      <xsl:attribute name="class">inline-note-<xsl:value-of select="@resp"/></xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="note[@place='inline']">
    <xsl:choose>
      <xsl:when test="//ref[@type='inline-note']/@target = @id"> 
          <!-- if there is a ref targetting this note, don't display;
             the note will display via ref -->
        </xsl:when> 
      <xsl:when test="@resp = 'auth'">
        <!-- no special formatting for author's notes -->
        <xsl:apply-templates/>
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
    <span>
      <xsl:choose>
        <xsl:when test="@rend">
          <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">hi</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </span>
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
  <img class="pageimage">
    <xsl:attribute name="src"><xsl:value-of select="concat($figure-path, @entity, $figure-suffix)"/></xsl:attribute>
    <xsl:attribute name="alt"><xsl:value-of select="normalize-space(figDesc)"/></xsl:attribute>
    <xsl:attribute name="title"><xsl:value-of select="normalize-space(figDesc)"/></xsl:attribute>
  </img>
</xsl:template>

<!-- translation -->
<xsl:template match="note[@type='trans']">
  <p class='trans'>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="note[@place='margin']">
  <span class="margin-note">(<xsl:apply-templates/>)</span>
</xsl:template>


<xsl:template match="note">
    <xsl:if test="@id">
      <a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute></a>
    </xsl:if>
    <hr class="note"/> 
  <div>
    <xsl:attribute name="class">note</xsl:attribute>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="author[name]|title[rs][not(ancestor::note)]">
  <a><xsl:attribute name="href">browse.php?category=<xsl:value-of select="name()"/>&amp;amp;key=<xsl:value-of select="*/@key"/></xsl:attribute><xsl:value-of select="normalize-space(.)"/></a>
</xsl:template>

</xsl:stylesheet>
