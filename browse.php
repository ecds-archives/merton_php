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
//$tamino = new xmlDbConnection($myargs);
$xmldb = new xmlDbConnection($myargs);
$pos = 1;
$max = 40;

if (isset($key)) { 
  // retrieve all quotes by a single author
  $xquery{"author"} = 'for $div in /TEI.2/text/body//div,
	$cit in $div/cit[bibl//*/@key="' . $key . '"]
return <div>{$div/@id}{$div/head}{$cit}</div>';
} else {
  // retrieve list of distinct authors & count of quotes
  $xquery{"author"} = 'let $doc := /TEI.2
for $a in distinct-values($doc/text/body//div/cit/bibl/author/name/@key)
let $b := distinct-values($doc/text/body//div/cit/bibl/author/name[@key=$a]/@reg)
let $c := count($doc/text/body//div/cit[bibl//@key=$a])
order by $b
return <author>
<key>{$a}</key>
<reg>{$b}</reg>
<count>{$c}</count>
</author>';
}

if (isset($key)) {
  $xquery{"language"} = 'for $div in /TEI.2/text/body//div,
	$cit in $div/cit[quote/@lang="' . $key . '"]
return <div>{$div/@id}{$div/head}{$cit}</div>';

} else {
  $xquery{"language"} = 'let $doc := /TEI.2
for $a in distinct-values($doc/text/body//div/cit/quote/@lang)
let $b := $doc/teiHeader/profileDesc/langUsage/language[@id=$a]
let $c := count($doc/text/body//div/cit/quote[@lang=$a])
order by $b
return <lang>
{$b}
<count>{$c}</count>
</lang>';
}

if (isset($key)) {
  $xquery{"title"} = 'for $div in /TEI.2/text/body//div,
	$cit in $div/cit[bibl/title/rs/@key="' . $key . '"]
return <div>{$div/@id}{$div/head}{$cit}</div>';
} else {
$xquery{"title"} = 'let $doc := /TEI.2
for $a in distinct-values($doc/text/body//div/cit/bibl/title/rs/@key)
let $b := distinct-values($doc/text/body//div/cit/bibl/title/rs[@key=$a]/@reg)
let $c := count($doc/text/body//div/cit[bibl//rs/@key=$a])
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
