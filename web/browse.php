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
  $xquery{"author"} = 'for $div in input()/TEI.2/:text/body//div,
	$cit in $div/cit[bibl//*/@key="' . $key . '"]
return <div>{$div/@id}{$div/head}{$cit}</div>';
} else {
  // retrieve list of distinct authors & count of quotes
  $xquery{"author"} = 'let $doc := input()/TEI.2
for $a in distinct-values($doc/:text/body//div/cit/bibl/author/name/@key)
let $b := distinct-values($doc/:text/body//div/cit/bibl/author/name[@key=$a]/@reg)
let $c := count($doc/:text/body//div/cit[bibl//@key=$a])
return <author>
<key>{$a}</key>
<reg>{$b}</reg>
<count>{$c}</count>
</author>';
}

if (isset($key)) {
  $xquery{"language"} = 'for $div in input()/TEI.2/:text/body//div,
	$cit in $div/cit[quote/@lang="' . $key . '"]
return <div>{$div/@id}{$div/head}{$cit}</div>';

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
  $xquery{"title"} = 'for $div in input()/TEI.2/:text/body//div,
	$cit in $div/cit[bibl/title/rs/@key="' . $key . '"]
return <div>{$div/@id}{$div/head}{$cit}</div>';
} else {
$xquery{"title"} = 'let $doc := input()/TEI.2
for $a in distinct-values($doc/:text/body//div/cit/bibl/title/rs/@key)
let $b := distinct-values($doc/:text/body//div/cit/bibl/title/rs[@key=$a]/@reg)
let $c := count($doc/:text/body//div/cit[bibl//rs/@key=$a])
return <title>
<key>{$a}</key>
<reg>{$b}</reg>
<count>{$c}</count>
</title>';
}


$xsl = "categories.xsl"; 

$tamino->xquery($xquery{$cat});
$tamino->xslTransform($xsl);

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
  print "<p>Quotations where $category = $key:</p>";
} else {
  print "<p>Quotations by $cat:</p>";
}


$tamino->printResult();
print "</div>
    </body>
    </html>";

?>