<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");

// use tamino settings from config file
//$myargs = $tamino_args;
$myargs = $exist_args;
$myargs{"debug"} = false;
//$tamino = new xmlDbConnection($myargs);
$xmldb = new xmlDbConnection($myargs);

// search terms
$kw = $_REQUEST["keyword"];
$kwarray = processterms($kw);


if ($kw)
  $query = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
declare option exist:serialize "highlight-matches=elements";';
  $query .= "for \$a in /tei:TEI/tei:text//tei:div[ft:query(., \"$kw\")]
   let \$matchcount := ft:score(\$a)
   order by \$matchcount descending
   return <div>
     {\$a/@type}
     {\$a/@xml:id}
     {\$a/tei:head}
     <matches><total>{\$matchcount}</total></matches>
   </div>";




/*
$declare ='declare namespace xs="http://www.w3.org/2001/XMLSchema"';
$for = 'for $a in /TEI.2/text//div';
$let = '';
$conditions = array();
$reflist = array();
for ($i = 0; $i < count($kwarray); $i++) {
  $let .= "let \$ref$i := tf:createTextReference(\$a, '$kwarray[$i]') "; //What exist function?
  array_push($reflist, "\$ref$i"); 
  array_push($conditions, "tf:containsText(\$a, '$kwarray[$i]')"); //What exist function?
 }
$let .= "let \$allrefs := (" . implode(",", $reflist) . ") ";
$where = "where " . implode(" and ", $conditions);
$return = 'return <div> 
  {$a/@type}
  {$a/@id}
  {$a/head}';
if ($kw) {
  $return .= '<matches><total>{count($allrefs)}</total>'; 
  for ($i = 0; $i < count($kwarray); $i++) {
    $return .= "<term>$kwarray[$i]<count>{count(\$ref$i)}</count></term>";
  }
  $return .= "</matches>";
 }
$return .= '</div>';

$sort = "sort by (xs:int(matches/total) descending) ";

$countquery = "<total>{count($for $where return \$a)}</total>";

$query = "$declare <result>$countquery\{$for $let $where $return $sort}</result>";
*/
//$tamino->xquery($query);
$xmldb->xquery($query);
$xsl = "xsl/search.xsl";
$param = array("keyword" => $kw);
//$tamino->xslTransform($xsl, $param);
$xmldb->xslTransform($xsl, $param);

/*

      $all = 'let $allrefs := (';
      $allcount = 'let $allcounts := (';
      for ($i = 0; $i < count($kwarray); $i++) {
	$term = ($mode == "phonetic") ? "tf:phonetic('$kwarray[$i]')" : "'$kwarray[$i]'";
	$let .= "let \$ref$i := tf:createTextReference(\$a//p, $term) ";
	$let .= "let \$count$i := tf:createTextReference(\$a//p//text()[not(parent::figDesc)], $term) ";
	if ($i > 0) { $all .= ", "; $allcount .= ", "; }
	$all .= "\$ref$i"; 
	$allcount .= "\$count$i"; 
        array_push($conditions, "tf:containsText(\$a, $term)");
      }
      $all .= ") ";
      $let .= $all;
      $allcount .= ") ";
      $let .= $allcount;
*/


$term = array();
if ($kw) {$term = array_merge($term, $kwarray); }


print "<html>
  <head> 
    <link rel='stylesheet' type='text/css' href='merton.css'>
    <title>Merton's Red Diary : Search Results</title> 
    <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
    <base href='$base_url'> 
  </head> 
<body> 
";

include("nav.xml");
include("header.xml");
print "<div class='content'>";

//$total = $tamino->findNode("total");
$total = $xmldb->findNode("exist:result/@exist:hits");

if ($total == 0){
  print "<p><b>No matches found.</b></p>";
  //	You may want to broaden your search and see search tips for suggestions.</p>";
} /*else {
  print "<h2>Search Results</h2>";
  print "<p>Found <b>" . $total . "</b> match";
  if ($total > 1) { print "es"; }
  print ". Results sorted by relevance.</p>"; 
  }*/

//$tamino->highlightInfo($myterms);
//$tamino->printResult($myterms);
$xmldb->highlightInfo($term);
$xmldb->printResult($term);
print "</div>";
include("google-trackmerton.xml");
print "</body>
    </html>";

?>