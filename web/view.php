<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");

// Get any div by id (front matter, back matter, pages, or sections) 
$id = $_GET["id"];
// search terms (if coming from search results)
$kw = $_GET["keyword"];

$kwarray = processterms($kw);

// use tamino settings from config file
$myargs = $tamino_args;
$myargs{"debug"} = false;
$tamino = new xmlDbConnection($myargs);

$xquery = 'let $a := input()/TEI.2/:text//div[@id="' . $id . '"]
return <result>
 {$a}
 <siblings>
  {for $b in input()/TEI.2/:text/front//div
  return <div>
   {$b/@id}
   {$b/head}
  </div>}
  {for $b in input()/TEI.2/:text/body//div[@type!="section"]
  return <div>
   {$b/@id}
   {$b/head}
  </div> sort by (@id)}
  {for $b in input()/TEI.2/:text/back//div
  return <div>
   {$b/@id}
   {$b/head}
  </div> }
 </siblings>
</result>';


// special cases: cover & frontispiece have no text & no div
if (($id == "cover")||($id == "frontispiece")) {
  $xquery = 'let $a := input()/TEI.2/:text//figure[@entity="' . $id . '"]
return $a';
 }


$xsl = "view.xsl"; 

$tamino->xquery($xquery);
$tamino->xslTransform($xsl);


$title = $tamino->findNode("head");
if ($title == '')
  $title = $id;	// special cases (cover & frontispiece)

print "<html>
  <head> 
    <link rel='stylesheet' type='text/css' href='merton.css'>
    <title>Merton's Red Diary : $title</title> 
    <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
  </head> 
<body> 
";
  
include("nav.xml");
include("header.xml");
print "<div class='content'>";
if ($kw) 
  $tamino->highlightInfo($kwarray);
$tamino->printResult($kwarray);
print "</div>
    </body>
    </html>";

?>

