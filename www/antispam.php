<?php

require_once("common.php");

$toon_id = $_REQUEST['id'];

// Antispam example using a random string
require_once "graphs/jplib/jpgraph_antispam.php";


$query = "SELECT last_challenge from toons where id = '$toon_id'";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
$line = pg_fetch_array($result, null, PGSQL_ASSOC);

$challenge = array_shift($line);

$spam = new AntiSpam($challenge);

pg_free_result($result);

// Stroke random cahllenge
if( $spam->Stroke() === false ) {
    die('Illegal or no data to plot');
}

?>

