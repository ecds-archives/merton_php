<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");

$myargs = $tamino_args;
$myargs{"debug"} = false;
$tamino = new xmlDbConnection($myargs);

$xquery = 'for $fig in input()/TEI.2/:text//figure
return <figure>{$fig/@*}{$fig/*}
<parent>{$fig/../@id}{$fig/../@type}{local-name($fig/..)}</parent>
</figure>';

$xsl = "facsimiles.xsl"; 

$tamino->xquery($xquery);
$tamino->xslTransform($xsl);

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
$tamino->printResult();
print "</div>";

?>
