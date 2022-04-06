<?php
include ("jplib/jpgraph.php");
include ("jplib/jpgraph_bar.php");
include ("../common.php");

if (! isset($_REQUEST['id'])) {
	header("Location:index.html");
	exit();
}

$id = $_REQUEST['id'];

$datax=array();

if ($id == 0) {
	$curr_year  = strftime("%Y");
	$curr_month = strftime("%m");

	if ($curr_month < 6) {
		$start_year  = $curr_year - 1;
		$start_month = $curr_month + 6;

		$where_clause = "(raid_year = '$start_year' AND raid_month > '$start_month') OR raid_year = '$curr_year'";
	} else {
		$start_month = $curr_month - 6;

		$where_clause = "raid_year = '$curr_year' AND raid_month > '$start_month'";
	}

	$query = "select raid_year, raid_month, sum(earned_dkp)::float(1) as edkp, sum(spent_dkp) as sdkp from view_dkphist_summary where $where_clause group by raid_year, raid_month order by raid_year, raid_month";
} else {
	$query = "select raid_year, raid_month, sum(earned_dkp)::float(1) as edkp, sum(spent_dkp) as sdkp from view_dkphist_summary where toon_id = '$id' group by raid_year, raid_month order by raid_year, raid_month";
}

$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$datay1=array();
$datay2=array();

while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$raid_year = array_shift($line);
	$raid_month = array_shift($line);
	$raid_dkp_earned = array_shift($line);
	$raid_dkp_spent = array_shift($line);

	$raid_date = $raid_month . '/' . $raid_year;

	array_push($datax,  $raid_date);
	array_push($datay1, $raid_dkp_earned);
	array_push($datay2, $raid_dkp_spent);
}

pg_free_result($result);

// Size of graph
$width=500; 
$height=100;

// Set the basic parameters of the graph 
$graph = new Graph($width,$height,'auto');
$graph->SetScale("textlin");
$graph->SetMargin(5, 10, 0, 0);

// Nice shadow
$graph->SetShadow();

// Setup title
$graph->title->Set("DKP");
$graph->subtitle->Set("Earned and Spent");

$graph->xaxis->SetTickLabels($datax);

$graph->xaxis->SetLabelMargin(5);

// Label align for X-axis
$graph->xaxis->SetLabelAlign('right','center');

// We don't want to display Y-axis
$graph->yaxis->Hide();

// Now create a bar pot
$bplot1 = new BarPlot($datay1);
$bplot1->SetFillColor("green");
$bplot1->SetShadow();
$bplot1->value->Show();
$bplot2 = new BarPlot($datay2);
$bplot2->SetFillColor("red");
$bplot2->SetShadow();
$bplot2->value->Show();

$bplot = new GroupBarPlot(array($bplot1, $bplot2));

//You can change the width of the bars if you like
$bplot->SetWidth(.5);

// We want to display the value of each bar at the top
$bplot1->value->SetAlign('right','center');
$bplot1->value->SetColor("black","darkred");
$bplot1->value->SetFormat('%d');
$bplot2->value->SetAlign('left','center');
$bplot2->value->SetColor("black","darkred");
$bplot2->value->SetFormat('%d');

// Add the bar to the graph
$graph->Add($bplot);

// .. and stroke the graph
$graph->Stroke();
?>
