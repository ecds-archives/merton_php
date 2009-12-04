<?php
print "<html>
  <head> 
    <link rel='stylesheet' type='text/css' href='merton.css'>
    <title>Merton's Red Diary</title> 
    <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
    <base href='$base_url'> 
";


/* load dublin core metadata to put in header */
$xml = new DomDocument();
$xml->load("metadata.xml");

$xsl = new DomDocument();
$xsl->load("xsl/dc-htmldc.xsl");

/* create processor & import stylesheet */
$proc = new XsltProcessor();
$xsl = $proc->importStylesheet($xsl);

/* transform the xml document into html-style dublin core */
$xsl_result = $proc->transformToDoc($xml);

print $xsl_result->saveXML();

print "\n  </head> 
<body> 
";

include("nav.xml");
include("header.xml");
include("intro.xml");
print "</div>";
include("google-trackmerton.xml");
print "</body>
    </html>";

?>