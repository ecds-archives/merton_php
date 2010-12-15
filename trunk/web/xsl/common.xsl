<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="1.0">

  <xsl:output method="xml"/>

  <xsl:variable name="figure-path">http://beck.library.emory.edu/merton/image-content/</xsl:variable>
  <xsl:variable name="figure-suffix">.jpg</xsl:variable>
  <xsl:variable name="thumbnail-path">http://beck.library.emory.edu/merton/image-content/thumbnails/</xsl:variable>
  <xsl:variable name="thumbnail-suffix">.gif</xsl:variable>


  <xsl:template match="tei:div">
    <div>
      <xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute>
      <xsl:apply-templates/>
    </div>    
  </xsl:template>

  <xsl:template match="tei:head">
    <p class="head"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="tei:byline">
    <p class="byline"><xsl:apply-templates/></p>   
  </xsl:template>

  <xsl:template match="tei:dateline">
    <p class="dateline"><xsl:apply-templates/></p>   
  </xsl:template>

  <!-- ignore diary dateline info for now -->
<!-- CD but dateline info isn't commented out - ? -->
  <xsl:template match="tei:div[@type='page']/tei:dateline"/>

  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="tei:lb">
    <br/>
  </xsl:template>

  <xsl:template match="tei:cit">
    <div class="citation"><xsl:apply-templates/></div>
  </xsl:template>

  <!-- keep note citations within note paragraph -->
  <xsl:template match="tei:note/tei:cit">
    <br/><span class="citation"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="tei:quote">
    <div class="quote"><xsl:apply-templates/></div>
  </xsl:template>

<!-- CD - not sure what to do with ancestor and note below -->
  <xsl:template match="tei:bibl[not(ancestor::note)]">
    <p class='bibl'>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:lg">
    <p class="lg"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="tei:l">
    <xsl:apply-templates/><br/>
  </xsl:template>
  
  <xsl:template match="tei:title">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="tei:author">
    <xsl:choose>
      <xsl:when test="@rend = 'underline'">
<<!-- CD - is underline a tei element? -->>
        <u><xsl:apply-templates/></u>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:list">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="tei:item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="tei:listBibl">
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
<!-- CD- does above need tei namespaces? -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <a><xsl:attribute name="href">view.php?id=<xsl:value-of select="@target"/></xsl:attribute>
          <xsl:apply-templates/></a>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

<!-- CD - completely unsure about tei namespace inserts below -->
  <xsl:key name="note-by-id" match="//tei:note" use="@id"/> 
<!-- CD- xml:id? -->

  <xsl:template match="tei:ref[@type='inline-note']">
    <!-- apply-templates for inline note matching target id... -->
    <xsl:apply-templates select="tei:key('note-by-id', @target)" mode="ref"/>
  </xsl:template>

  <xsl:template match="tei:note[@place='inline']" mode="ref">
    <span>
      <xsl:attribute name="class">inline-note-<xsl:value-of select="@resp"/></xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:note[@place='inline']">
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

  <xsl:template match="tei:foreign">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="tei:hi">
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

<xsl:template match="tei:milestone">
  <xsl:element name="p">
    <xsl:attribute name="class">milestone</xsl:attribute>
    <xsl:choose>
      <xsl:when test="@rend='plus'">
        <xsl:text>+</xsl:text>
      </xsl:when>      
    </xsl:choose>
  </xsl:element>
</xsl:template>

<xsl:template match="tei:figure">
  <img class="pageimage">
    <xsl:attribute name="src"><xsl:value-of select="concat($figure-path, @entity, $figure-suffix)"/></xsl:attribute>
    <xsl:attribute name="alt"><xsl:value-of select="normalize-space(figDesc)"/></xsl:attribute>
    <xsl:attribute name="title"><xsl:value-of select="normalize-space(figDesc)"/></xsl:attribute>
  </img>
</xsl:template>

<!-- translation -->
<xsl:template match="tei:note[@type='trans']">
  <p class='trans'>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="tei:note[@place='margin']">
  <span class="margin-note">(<xsl:apply-templates/>)</span>
</xsl:template>


<xsl:template match="tei:note">
    <xsl:if test="@id">
<!-- CD xml id? -->
      <a><xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute></a>
    </xsl:if>
    <hr class="note"/> 
  <div>
    <xsl:attribute name="class">note</xsl:attribute>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="tei:author[tei:name]|tei:title[tei:rs][not(ancestor::note)]">
<!-- CD check line above -->
  <xsl:text> </xsl:text><a><xsl:attribute name="href">browse.php?category=<xsl:value-of select="name()"/>&amp;amp;key=<xsl:value-of select="*/@key"/></xsl:attribute><xsl:value-of select="normalize-space(.)"/></a>
</xsl:template>

</xsl:stylesheet>
