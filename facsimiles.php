<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");

//$myargs = $tamino_args;
$myargs = $exist_args;
$myargs{"debug"} = false;
//$tamino = new xmlDbConnection($myargs);
$xmldb = new xmlDbConnection($myargs);
$pos = 1;
$max = 65;

$xquery = 'for $fig in /TEI.2/text//figure
return <figure>{$fig/@*}{$fig/*}
<parent>{$fig/../@id}{$fig/../@type}{local-name($fig/..)}</parent>
</figure>';

$xsl = "xsl/facsimiles.xsl"; 

//$tamino->xquery($xquery);
//$tamino->xslTransform($xsl);
$xmldb->xquery($xquery, $pos, $max);
$xmldb->xslTransform($xsl);

print "<html>
  <head>
   <link rel='stylesheet' type='text/css' href='merton.css'>
    <title>Merton's Red Diary : Facsimiles of Pages</title>  
    <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
  </head> 
<body> 
";

include("nav.xml");
include("header.xml");
print "<div class='content'>";
//$tamino->printResult();
$xmldb->printResult();
print "</div>";

?>
