<?php

if (isset($_REQUEST['id'])) {
	$raid_id = $_REQUEST['id'];
} else {
	header("Location: ../index.php");
	exit();
}

require_once("../common.php");

include ("jplib/jpgraph.php");
include ("jplib/jpgraph_gantt.php");

$graph = new GanttGraph(800);
$graph->SetMarginColor('blue:1.7');
$graph->SetColor('white');
$graph->img->SetImgFormat('jpeg');

$graph->SetBackgroundGradient('navy','white',GRAD_HOR,BGRAD_MARGIN);
$graph->scale->hour->SetBackgroundColor('lightyellow:1.5');
$graph->scale->day->SetBackgroundColor('lightyellow:1.5');

$graph->title->Set("Raid Roster");
$graph->title->SetColor('white');

//$graph->ShowHeaders(GANTT_HDAY | GANTT_HHOUR | GANTT_HMIN);
$graph->ShowHeaders(GANTT_HDAY | GANTT_HHOUR);

$graph->scale->actinfo->SetColTitles(array('Raider','CT','DKP'));
$graph->scale->actinfo->vgrid->SetColor('gray');
$graph->scale->actinfo->SetColor('darkgray');
$graph->scale->actinfo->SetColumnMargin(5,30);

$graph->scale->week->SetStyle(WEEKSTYLE_FIRSTDAY);
$graph->scale->hour->SetIntervall(1);

$graph->scale->minute->SetIntervall(30);
$graph->scale->minute->SetBackgroundColor('lightyellow:1.5');
$graph->scale->minute->SetStyle(MINUTESTYLE_MM);
$graph->scale->minute->grid->SetColor('lightgray');

$graph->scale->hour->SetStyle(HOURSTYLE_H24);
$graph->scale->day->SetStyle(DAYSTYLE_SHORTDAYDATE3);

$query = "SELECT va.name, tc.name as class, va.first_join, va.last_leave, va.clock_time, va.earned_dkp::float(3) FROM view_attendance va, toons t, toon_classes tc where va.raid_id = '$raid_id'  and va.toon_id = t.id and t.class_id = tc.id order by name";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$toon_name  = array_shift($line);
	$toon_class = array_shift($line);
	$first_join = array_shift($line);
	$last_leave = array_shift($line);
	$clock_time = array_shift($line);
	$earned_dkp = array_shift($line);

	$bar = new GanttBar($i++,array($toon_name,$clock_time,$earned_dkp),$first_join,$last_leave,"",0.75);
	$bar->SetPattern(GANTT_3DPLANE,"yellow");
	$bar->SetFillColor("green");
	$graph->Add($bar);
}

pg_free_result($result);

$graph->Stroke();



?>



