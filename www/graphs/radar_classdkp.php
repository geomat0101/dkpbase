<?php
require_once("../common.php");
include ("jplib/jpgraph.php");
include ("jplib/jpgraph_radar.php");
    
// Some data to plot
$data = array();
$data2 = array();
$titles = array();

if (isset($_REQUEST['year']) && isset($_REQUEST['month']))  {
	$year  = $_REQUEST['year'];
	$month = $_REQUEST['month'];

	$subtitle = "Raids and Loot from $month/$year";
	$query = "select name, earned_dkp, spent_dkp from view_dkphist_summary_byclass where raid_year = '$year' AND raid_month = '$month'";
} else {
	$subtitle = 'Overall (All Recorded Raids and Loot)';
	$query = "select name, sum(earned_dkp) as earned_dkp, sum(spent_dkp) as spent_dkp from view_dkphist_summary_byclass group by name order by name";
}
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$class_name = array_shift($line);
	$class_earned = array_shift($line);
	$class_spent = array_shift($line);

	array_push($titles, $class_name);
	array_push($data, $class_earned);
	array_push($data2, $class_spent);
}
    
// Create the graph and the plot
$graph = new RadarGraph(800,600,"auto");

// Add a drop shadow to the graph
$graph->SetShadow();

// Create the titles for the axis
$graph->SetTitles($titles);
$graph->SetColor('lightblue');
$graph->title->Set('DKP Earned / Spent By Class');
$graph->subtitle->Set($subtitle);

// Add grid lines
$graph->grid->Show();
$graph->grid->SetColor('darkred');
$graph->grid->SetLineStyle('dotted');

$plot = new RadarPlot($data);
$plot->SetFillColor('lightgreen');

$plot2 = new RadarPlot($data2);
$plot2->SetColor('red');
$plot2->SetFill(false);
$plot2->SetLineWeight(2);


// Add the plot and display the graph
$graph->Add($plot);
$graph->Add($plot2);
$graph->Stroke();
?> 
