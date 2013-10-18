<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
		xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:output method="xml"/>

  <xsl:variable name="figure-path">http://beck-dev.ecdsweb.org/merton/image-content/</xsl:variable>
  <!-- <xsl:variable name="figure-suffix">.jpg</xsl:variable> -->
  <xsl:variable name="thumbnail-path">http://beck-dev.ecdsweb.org/merton/image-content/thumbnails/</xsl:variable>
  <xsl:variable name="thumbnail-suffix">.gif</xsl:variable>
  <xsl:variable name="target"><xsl:value-of select="substring-after(@target, '#')"/></xsl:variable>


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

  <xsl:template match="tei:bibl[not(ancestor::tei:note)]">
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
    <xsl:choose>
      <xsl:when test="child::tei:rs">
          <i><xsl:apply-templates select="tei:rs"/></i>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:author">
    <xsl:choose>
      <xsl:when test="@rend = 'underline'">
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
  
  <xsl:template match="tei:listBibl/tei:bibl">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="tei:ref">
  <xsl:variable name="target"><xsl:value-of select="substring-after(@target, '#')"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="ancestor::tei:div//tei:note/@xml:id=$target">
        <!-- if the ref refers to a note in this section but is NOT inline,
             don't create a link -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <a><xsl:attribute name="href">view.php?id=<xsl:value-of select="$target"/></xsl:attribute>
          <xsl:apply-templates/></a>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:key name="note-by-id" match="//tei:note" use="@xml:id"/>

  <xsl:template match="tei:ref[@type='inline-note']">
    <!-- apply-templates for inline note matching target id... -->
    <xsl:apply-templates select="key('note-by-id', $target)" mode="ref"/>
  </xsl:template>

  <xsl:template match="tei:note[@place='inline']" mode="ref">
    <span>
      <xsl:attribute name="class">inline-note-<xsl:value-of select="substring-after(@resp, '#')"/></xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:note[@place='inline']">
    <xsl:choose>
      <xsl:when test="//tei:ref[@type='inline-note']/@target = concat('#', @xml:id)"> 
          <!-- if there is a ref targetting this note, don't display;
             the note will display via ref -->
        </xsl:when> 
      <xsl:when test="@resp = '#auth'">
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
    <xsl:attribute name="src"><xsl:value-of select="concat($figure-path, tei:graphic/@url)"/></xsl:attribute>
    <xsl:attribute name="alt"><xsl:value-of select="normalize-space(tei:figDesc)"/></xsl:attribute>
    <xsl:attribute name="title"><xsl:value-of select="normalize-space(tei:figDesc)"/></xsl:attribute>
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
    <xsl:if test="@xml:id">
      <a><xsl:attribute name="name"><xsl:value-of select="@xml:id"/></xsl:attribute></a>
    </xsl:if>
    <hr class="note"/> 
  <div>
    <xsl:attribute name="class">note</xsl:attribute>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="tei:author[tei:name] | tei:title[tei:rs][not(ancestor::tei:note)] | tei:title[not(child::tei:rs)][not(ancestor::tei:note)]">
<xsl:variable name="selection">
<xsl:choose>
  <xsl:when test="name()='author'"> 
    <xsl:choose>
      <xsl:when test="child::tei:name/tei:choice">
    <xsl:value-of select="normalize-space(tei:name/tei:choice/tei:sic)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="normalize-space(tei:name)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:when test="name()='title'">
    <xsl:choose>
      <xsl:when test="child::tei:rs">
	<xsl:value-of select="normalize-space(tei:rs)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
</xsl:choose></xsl:variable>
<xsl:choose>
  <xsl:when test="name()='title' and not(child::tei:rs)">
	    <!-- <a><xsl:attribute name="href">browse.php?category=<xsl:value-of select="name()"/></xsl:attribute><xsl:value-of select="$selection"/></a> --><i><xsl:apply-templates/></i>
  </xsl:when>
  <xsl:when test="name()='title' and parent::tei:item">
    <i><xsl:value-of select="normalize-space(tei:rs)"/></i>
  </xsl:when>
  <xsl:otherwise>
  <a><xsl:attribute name="href">browse.php?category=<xsl:value-of select="name()"/>&amp;key=<xsl:value-of select="*/@key"/></xsl:attribute><xsl:value-of select="$selection"/></a>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- <xsl:template match="tei:title/tei:rs"> -->
<!--   <xsl:value-of select="normalize-space()"/> -->
<!-- </xsl:template> -->
</xsl:stylesheet>
