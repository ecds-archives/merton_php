<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");

// Get any div by id (front matter, back matter, pages, or sections) 
if (isset($_REQUEST["id"]))
$id = $_REQUEST["id"];
// search terms (if coming from search results)
if (isset($_REQUEST["keyword"])) {
$kw = $_REQUEST["keyword"];
$term = processterms($kw);
 }

// use exist settings from config file
//$myargs = $tamino_args;
$myargs = $exist_args;
$myargs{"debug"} = false;
//$tamino = new xmlDbConnection($myargs);
$xmldb = new xmlDbConnection($myargs);

$xquery = "declare option exist:serialize 'highlight-matches=all';";
$xquery .= 'let $a := /TEI.2/text//div[@id="' . $id . '"]
return <result>
 {$a}
 <siblings>
  {for $b in /TEI.2/text/front//div
  return <div>
   {$b/@id}
   {$b/head}
  </div>}
  {for $b in /TEI.2/text/body//div[@type!="section"]
     order by ($b/@id)
  return <div>
   {$b/@id}
   {$b/head}
  </div>}
  {for $b in /TEI.2/text/back//div
  return <div>
   {$b/@id}
   {$b/head}
  </div> }
 </siblings>
</result>';


// special cases: cover & frontispiece have no text & no div
if (($id == "cover")||($id == "frontispiece")) {
  $xquery = 'let $a := /TEI.2/text//figure[@entity="' . $id . '"]
return $a';
 }


$xsl = "xsl/view.xsl"; 

//$tamino->xquery($xquery);
//$tamino->xslTransform($xsl);
$xmldb->xquery($xquery);
$xmldb->xslTransform($xsl);



//$title = $tamino->findNode("head");
$title = $xmldb->findNode("head");
if ($title == '')
  $title = $id;	// special cases (cover & frontispiece)

print "<html>
  <head> 
    <link rel='stylesheet' type='text/css' href='merton.css'>
    <title>Merton's Red Diary : $title</title> 
    <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>
    <base href='$base_url'> 
  </head> 
<body> 
";
  
include("nav.xml");
include("header.xml");
print "<div class='content'>";
if (isset($kw)) {
  //$tamino->highlightInfo($kwarray);
  //$tamino->printResult($kwarray);
$xmldb->highlightInfo($term);
$xmldb->printResult($term);
 }
 else $xmldb->printResult();
print "</div>";
include("google-trackmerton.xml");
print "</body>
    </html>";

?>

