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

$xquery = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
declare option exist:serialize "highlight-matches=element";';
$xquery .= 'let $a := /tei:TEI/tei:text//tei:div[@xml:id="' . $id . '"]
return <result>
 {$a}
 <siblings>
  {for $b in /tei:TEI/tei:text/tei:front//tei:div
  return <div>
   {$b/@xml:id}
   {$b/tei:head}
  </div>}
  {for $b in /tei:TEI/tei:text/tei:body//tei:div[@type!="section"]
     order by ($b/@xml:id)
  return <div>
   {$b/@xml:id}
   {$b/tei:head}
  </div>}
  {for $b in /tei:TEI/tei:text/tei:back//tei:div
  return <div>
   {$b/@xml:id}
   {$b/tei:head}
  </div> }
 </siblings>
</result>';


// special cases: cover & frontispiece have no text & no div
if (($id == "cover")||($id == "frontispiece")) {
  $xquery = 'let $a := /tei:TEI/tei:text//tei:figure[tei:graphic/@url="' . $id . '"]
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

