<?php
require_once("../common.php");

include ("jplib/jpgraph.php");
include ("jplib/jpgraph_scatter.php");

$graph = new Graph(800,600,"auto");
$graph->SetScale("linlin");
$graph->SetTickDensity(TICKD_NORMAL, TICKD_VERYSPARSE);

$graph->img->SetMargin(40,40,40,40);        
$graph->SetShadow();

$graph->title->Set("DKP vs. CT");
$graph->title->SetFont(FF_FONT1,FS_BOLD);

$datax = array();
$datay = array();
$sp = array();
$spmark = array(MARK_STAR, MARK_X, MARK_UTRIANGLE, MARK_SQUARE, MARK_FILLEDCIRCLE);
$spcolor = array('red', 'orange', 'green', 'blue', 'black');

$query = "select rank, rank_id, available_dkp, extract(epoch from current_clock_time) from view_agg_summary where current_clock_time > '00:00:00' order by rank_id desc";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
$curr_rank = '';
$spnum = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$rank = array_shift($line);
	$rank_id = array_shift($line);
	$dkp = array_shift($line);
	$ct  = array_shift($line);

	if ($curr_rank == '') {
		$curr_rank = $rank;
	} else if ($rank != $curr_rank) {
		$sp[$spnum] = new ScatterPlot($datay,$datax);
		$sp[$spnum]->SetLegend($curr_rank);
		$sp[$spnum]->mark->SetColor($spcolor[$spnum]);
		$sp[$spnum]->mark->SetType($spmark[$spnum]);

		$graph->Add($sp[$spnum++]);

		$datax = array();
		$datay = array();

		$curr_rank = $rank;
	}

	array_push($datay, $dkp);
	array_push($datax, $ct);
}

$sp[$spnum] = new ScatterPlot($datay,$datax);
$sp[$spnum]->SetLegend($curr_rank);
$sp[$spnum]->mark->SetColor($spcolor[$spnum]);
$sp[$spnum]->mark->SetType($spmark[$spnum]);

$graph->Add($sp[$spnum]);

pg_free_result($result);

$graph->Stroke();

?>
