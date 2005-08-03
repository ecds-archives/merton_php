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

$tamino->printResult();

?>
