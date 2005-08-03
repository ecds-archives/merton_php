<?php

include("config.php");
include_once("lib/xmlDbConnection.class.php");

// Get any div by id (front matter, back matter, pages, or sections) 
$cat = $_GET["category"];	// author, language, or title
if ($cat == '') { $cat = "author"; }	// default display
$key = $_GET["key"];	// key of specific author/title/lang to retrieve

// use exist settings from config file
$myargs = $tamino_args;
$myargs{"debug"} = false;
$tamino = new xmlDbConnection($myargs);

if (isset($key)) { 
  // retrieve all quotes by a single author
  $xquery{"author"} = 'let $a := input()/TEI.2/:text/body//div/cit[bibl//*/@key="' . $key . '"]
return $a';
} else {
  // retrieve list of distinct authors & count of quotes
  $xquery{"author"} = 'let $doc := input()/TEI.2
for $a in distinct-values($doc/:text/body//div/cit/bibl/author/name/@key)
let $b := distinct-values($doc/:text/body//div/cit/bibl/author/name[@key=$a]/@reg)
let $c := count($doc/:text/body//div/cit/[bibl//*@key=$a])
return <author>
<key>{$a}</key>
<reg>{$b}</reg>
<count>{$c}</count>
</author>';
}

if (isset($key)) {
  $xquery{"language"} = 'let $a := input()/TEI.2/:text/body//div/cit[quote/@lang="' . $key . '"]
return $a';
} else {
  $xquery{"language"} = 'let $doc := input()/TEI.2
for $a in distinct-values($doc/:text/body//div/cit/quote/@lang)
let $b := $doc/teiHeader/profileDesc/langUsage/language[@id=$a]
let $c := count($doc/:text/body//div/cit/quote[@lang=$a])
return <lang>
{$b}
<count>{$c}</count>
</lang>';
}

if (isset($key)) {
  $xquery{"title"} = 'let $a := input()/TEI.2/:text/body//div/cit[bibl/title/rs/@key="' . $key . '"]
return $a';
} else {
$xquery{"title"} = 'let $doc := input()/TEI.2
for $a in distinct-values($doc/:text/body//div/cit/bibl/title/rs/@key)
let $b := distinct-values($doc/:text/body//div/cit/bibl/title/rs[@key=$a]/@reg)
let $c := count($doc/:text/body//div/cit/[bibl//rs/@key=$a])
return <title>
<key>{$a}</key>
<reg>{$b}</reg>
<count>{$c}</count>
</title>';
}


$xsl = "categories.xsl"; 

$tamino->xquery($xquery{$cat});
$tamino->xslTransform($xsl);

print "<p><b>Browse quotations by category:</b><br/>";
print '<a href="browse.php?category=author">Author</a><br/>';
print '<a href="browse.php?category=language">Language</a><br/>';
print '<a href="browse.php?category=title">Source title</a><br/>';
print "</p>";

if (isset($key)) {
  print "<p>Quotations where $category = $key:</p>";
} else {
  print "<p>Quotations by $cat:</p>";
}

$tamino->printResult();

?>
