<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");


//$myargs = $tamino_args;
$myargs =  $exist_args;
$myargs{"debug"} = true;
//$tamino = new xmlDbConnection($myargs);
$xmldb = new xmlDbConnection($myargs);

$xquery = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
<result>
{let $t := /tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt
return $t}
{for $a in /tei:TEI//tei:div
return <div>{$a/@xml:id}{$a/@type}
{$a/tei:head}
<parent>{$a/../@xml:id}{local-name($a/..)}</parent>
</div>}
</result>';

$xsl = "xsl/contents.xsl"; 

//$tamino->xquery($xquery);
//$tamino->xslTransform($xsl);
$xmldb->xquery($xquery);
$xmldb->xslTransform($xsl);

print "<html>
  <head> 
    <link rel='stylesheet' type='text/css' href='merton.css'>
    <title>Merton's Red Diary : Contents</title> 
    <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
    <base href='$base_url'> 
  </head> 
<body> 
";

include("nav.xml");
include("header.xml");
print "<div class='content'>";
//$tamino->printResult();
$xmldb->printResult();
print "</div>";
include("google-trackmerton.xml");
print "</body>
    </html>";

?>
