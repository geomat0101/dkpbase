<?php
include ("jplib/jpgraph.php");
include ("jplib/jpgraph_bar.php");
include ("../common.php");

if (! isset($_REQUEST['id'])) {
	header("Location:index.html");
}

$id = $_REQUEST['id'];

if ($id == 0) {
	$query = "select dungeon, count(*) from view_raids group by dungeon order by dungeon";
} else {
	$query = "select dungeon, count(*) from view_attendance where toon_id = '$id' group by dungeon order by dungeon";
}

$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$datay=array();
$datax=array();

while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$dun_name = array_shift($line);
	$dun_count = array_shift($line);

	array_push($datay,  $dun_name);
	array_push($datax, $dun_count);
}

pg_free_result($result);

// Size of graph
$width=300; 
$height=100;

// Set the basic parameters of the graph 
$graph = new Graph($width,$height,'auto');
$graph->SetScale("textlin");

// Rotate graph 90 degrees and set margin
$graph->Set90AndMargin(150);

// Nice shadow
$graph->SetShadow();

// Setup title

$graph->xaxis->SetTickLabels($datay);

$graph->xaxis->SetLabelMargin(5);

// Label align for X-axis
$graph->xaxis->SetLabelAlign('right','center');

// We don't want to display Y-axis
$graph->yaxis->Hide();

// Now create a bar pot
$bplot = new BarPlot($datax);
$bplot->SetFillColor("purple");
$bplot->SetShadow();

//You can change the width of the bars if you like
$bplot->SetWidth(.5);

// We want to display the value of each bar at the top
$bplot->value->Show();
$bplot->value->SetAlign('left','center');
$bplot->value->SetColor("black","darkred");
$bplot->value->SetFormat('%d');

// Add the bar to the graph
$graph->Add($bplot);

// .. and stroke the graph
$graph->Stroke();
?>
