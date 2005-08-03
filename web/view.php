<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");

// Get any div by id (front matter, back matter, pages, or sections) 
$id = $_GET["id"];

// use exist settings from config file
$myargs = $tamino_args;
$myargs{"debug"} = true;
$tamino = new xmlDbConnection($myargs);

$xquery = 'let $a := input()/TEI.2/:text//div[@id="' . $id . '"]
return $a';

$xsl = "view.xsl"; 

$tamino->xquery($xquery);
$tamino->xslTransform($xsl);
$tamino->printResult();

?>

