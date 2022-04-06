<?php
include ("jplib/jpgraph.php");
include ("jplib/jpgraph_bar.php");
include ("../common.php");

$query = "select t.name as toon, t.alt, extract(epoch from vaacc.current_clock_time) as current_clock_time, extract(epoch from (vaa.all_clock_time - vaacc.current_clock_time)) as expired_time from view_agg_attendance vaa, view_agg_attendance_curr_ct vaacc, toons t where t.id = vaa.toon_id and vaa.toon_id = vaacc.toon_id order by current_clock_time desc limit 50";

$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$datay=array();
$datax1=array();
$datax2=array();

while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$toon_name = array_shift($line);
	$toon_alt  = array_shift($line);
	$toon_cur_ct = array_shift($line);
	$toon_exp_ct = array_shift($line);

	if ($toon_alt == 't') {
		$toon_name .= '*';
	}

	array_push($datay,  $toon_name);
	array_push($datax1, $toon_cur_ct);
	array_push($datax2, $toon_exp_ct);
}

pg_free_result($result);

// Size of graph
$width=800; 
$height=600;

// Set the basic parameters of the graph 
$graph = new Graph($width,$height,'auto');
$graph->SetScale("textlin");

// Rotate graph 90 degrees and set margin
$graph->Set90AndMargin(100,20,50,30);

// Nice shadow
$graph->SetShadow();

// Setup title
$graph->title->Set("Clock Time");
$graph->subtitle->Set("Top 50 (current CT)");

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
$bplot1->SetLegend("Current");
$bplot2 = new BarPlot($datax2);
$bplot2->SetFillColor("blue");
$bplot2->SetShadow();
$bplot2->SetLegend("Expired");

$bplot = new AccBarPlot(array($bplot1, $bplot2));

//You can change the width of the bars if you like
$bplot->SetWidth(.75);

// We want to display the value of each bar at the top
//$bplot->value->Show();
//$bplot->value->SetAlign('left','center');
//$bplot->value->SetColor("black","darkred");
//$bplot->value->SetFormat('%.1f mkr');

// Add the bar to the graph
$graph->Add($bplot);

// .. and stroke the graph
$graph->Stroke();
?>
