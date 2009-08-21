<?php

/* Configuration settings for entire site */

// set level of php error reporting -- turn off warnings when in production
//error_reporting(E_ERROR | E_PARSE);


// root directory and url where the website resides
  /* $server = "biliku.library.emory.edu";
$base_path = "/rebecca/merton";
$basedir = "/home/httpd/html$base_path";
$base_url = "http://$server$base_path/"; */

$in_production = true;

if ($in_production) {
  $server = "bohr.library.emory.edu";           //production
} else {
  $server = "wilson.library.emory.edu";         // test
}

//development
/*$base_path = "/~ahickco/merton";
$basedir = "/home/ahickco/public_html/merton";
$base_url = "http://$server$base_path/";
*/

//production
$base_path = "/merton";
$basedir = "home/httpd/html/beck/$base_path";
$base_url = "http://$server$basepath";

// add basedir to the php include path (for header/footer files and lib directory)
set_include_path(get_include_path() . ":" . $basedir . ":" . "$basedir/lib");

/* tamino settings  */
//$config{"server"} = "vip.library.emory.edu";
//$config{"db"} = "BECKCTR";
//$config{"coll"} = "merton";

// base settings for all connections to exist
/*$tamino_args = array('host'   => $config{"server"},
		     'db'     => $config{"db"},
		     'coll'   => $config{"coll"},
		     'dbtype' => 'tamino');*/

/* eXist settings */
$port = "8080";
$db = "merton";

$exist_args = array('host'   => $server,
	      	    'port'   => $port,
		    'db'     => $db,
		    'dbtype' => "exist");



//Function that takes multiple terms separated by white spaces and puts them into an array
function processterms ($str) {
// clean up input so explode will work properly
    $str = preg_replace("/\s+/", " ", $str);  // multiple white spaces become one space
    $str = preg_replace("/\s$/", "", $str);	// ending white space is removed
    $str = preg_replace("/^\s/", "", $str);  //beginning space is removed
    $terms = explode(" ", $str);    // multiple search terms, divided by spaces
    return $terms;
}

?>
