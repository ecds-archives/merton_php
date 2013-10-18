<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");

// Get any div by id (front matter, back matter, pages, or sections) 
if (isset($_REQUEST["category"]))
$cat = $_REQUEST["category"];	// author, language, or title
if(!isset($cat)) { $cat = "author"; }	// default display
if (isset($_REQUEST["key"]))
$key = $_REQUEST["key"];	// key of specific author/title/lang to retrieve

// use exist settings from config file
//$myargs = $tamino_args;
$myargs = $exist_args;
$myargs{"debug"} = false;
//$myargs{"debug"} = true;
//$tamino = new xmlDbConnection($myargs);
$xmldb = new xmlDbConnection($myargs);
$pos = 1;
$max = 40;

if (isset($key)) { 
  // retrieve all quotes by a single author
  $xquery{"author"} = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
        for $div in /tei:TEI/tei:text/tei:body//tei:div,
	$cit in $div/tei:cit[tei:bibl//*/@key="' . $key . '"]
return <div>{$div/@xml:id}{$div/tei:head}{$cit}</div>';
} else {
  // retrieve list of distinct authors & count of quotes
  $xquery{"author"} = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
let $doc := /tei:TEI
for $a in distinct-values($doc/tei:text/tei:body//tei:bibl/tei:author/tei:name/@key)
let $b := distinct-values($doc/tei:text/tei:body//tei:bibl/tei:author/tei:name[@key=$a]/tei:choice/tei:reg)
let $c := count($doc/tei:text//tei:cit[tei:bibl//@key=$a])
order by $b
return <author>
<key>{$a}</key>
<reg>{$b}</reg>
<count>{$c}</count>
</author>';
}

if (isset($key)) {
  $xquery{"language"} = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
        for $div in /tei:TEI/tei:text/tei:body//tei:div,
	$cit in $div/tei:cit[tei:quote/@lang="' . $key . '"]
return <div>{$div/@xml:id}{$div/tei:head}{$cit}</div>';

} else {
  $xquery{"language"} = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
let $doc := /tei:TEI
for $a in distinct-values($doc/tei:text/tei:body//tei:div/tei:cit/tei:quote/@xml:lang)
let $b := $doc/tei:teiHeader/tei:profileDesc/tei:langUsage/tei:language[@ident=$a]
let $c := count($doc/tei:text/tei:body//tei:div/tei:cit/tei:quote[@xml:lang=$a])
order by $b
return <lang>
{$b}
<count>{$c}</count>
</lang>';
}

if (isset($key)) {
  $xquery{"title"} = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
        for $div in /tei:TEI/tei:text/tei:body//tei:div,
	$cit in $div/tei:cit[tei:bibl/tei:title/tei:rs/@key="' . $key . '"]
return <div>{$div/@xml:id}{$div/tei:head}{$cit}</div>';
} else {
$xquery{"title"} = 'declare namespace tei="http://www.tei-c.org/ns/1.0";
let $doc := /tei:TEI
for $a in distinct-values($doc/tei:text/tei:body//tei:div/tei:cit/tei:bibl/tei:title/tei:rs/@key)
let $b := distinct-values($doc/tei:text/tei:body//tei:div/tei:cit/tei:bibl/tei:title/tei:rs[@key=$a]/@n)
let $c := count($doc/tei:text/tei:body//tei:div/tei:cit[tei:bibl//tei:rs/@key=$a])
order by $b
return <title>
<key>{$a}</key>
<reg>{$b}</reg>
<count>{$c}</count>
</title>';
}


$xsl = "xsl/categories.xsl"; 

//$tamino->xquery($xquery{$cat});
//$tamino->xslTransform($xsl);

$xmldb->xquery($xquery{$cat}, $pos, $max);
$xmldb->xslTransform($xsl);

print "<html>
  <head>
   <link rel='stylesheet' type='text/css' href='merton.css'>
    <title>Merton's Red Diary : Browse by Category</title>  
    <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
  </head> 
<body> 
";

include("nav.xml");
include("header.xml");
print "<div class='content'>";

print "<p><b>Browse quotations by category:</b><br/>
<a href='browse.php?category=author'>Author</a><br/>
<a href='browse.php?category=language'>Language</a><br/>
<a href='browse.php?category=title'>Source title</a><br/>
</p>";

if (isset($key)) {
  print "<p>Quotations where $cat = $key:</p>";
} else {
  print "<p>Quotations by $cat:</p>";
}


//$tamino->printResult();
$xmldb->printResult();
print "</div>";
include("google-trackmerton.xml");
print    "</body>
    </html>";
?>
