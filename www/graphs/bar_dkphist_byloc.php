<?php
include ("jplib/jpgraph.php");
include ("jplib/jpgraph_bar.php");
include ("../common.php");

if (! isset($_REQUEST['id'])) {
	header("Location:index.html");
}

$id = $_REQUEST['id'];

if ($id == 0) {
	header("Location:index.html");
} else {
        $query = "select dungeon, sum(earned_dkp)::float(1) as edkp, sum(spent_dkp) as sdkp from view_dkphist_summary where toon_id = '$id' group by dungeon order by dungeon";
}

$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$datay=array();
$datax1=array();
$datax2=array();

while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$dun_name = array_shift($line);
	$dun_earned = array_shift($line);
	$dun_spent = array_shift($line);

	array_push($datay,  $dun_name);
	array_push($datax1, $dun_earned);
	array_push($datax2, $dun_spent);
}

pg_free_result($result);

// Size of graph
$width=300; 
$height=200;

// Set the basic parameters of the graph 
$graph = new Graph($width,$height,'auto');
$graph->SetScale("textlin");

// Rotate graph 90 degrees and set margin
$graph->Set90AndMargin(120);

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
$bplot1 = new BarPlot($datax1);
$bplot1->SetFillColor("green");
$bplot1->SetShadow();

//You can change the width of the bars if you like
$bplot1->SetWidth(.25);

// We want to display the value of each bar at the top
$bplot1->value->Show();
$bplot1->value->SetAlign('left','center');
$bplot1->value->SetColor("black","darkred");
$bplot1->value->SetFormat('%d');

// Now create a bar pot
$bplot2 = new BarPlot($datax2);
$bplot2->SetFillColor("red");
$bplot2->SetShadow();

//You can change the width of the bars if you like
$bplot2->SetWidth(.25);

// We want to display the value of each bar at the top
$bplot2->value->Show();
$bplot2->value->SetAlign('left','center');
$bplot2->value->SetColor("black","darkred");
$bplot2->value->SetFormat('%d');

// Add the bar to the graph
$bplot = new GroupBarPlot(array($bplot1, $bplot2));
$bplot->SetWidth(.75);
$graph->Add($bplot);

$graph->title->Set('DKP');
$graph->subtitle->Set('Earned / Spent by Dungeon');

// .. and stroke the graph
$graph->Stroke();
?>
