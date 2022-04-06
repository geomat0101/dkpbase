<?

// $Id: index.php,v 1.12 2006/12/04 17:39:43 mdg Exp $

require_once("common.php");
?>

<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP</title>
</head>
<body>

<?
include('header.php');

?>
<table align=center width=100% valign=top border=0 cellspacing=0>
<tr align=center><td><img src=graphs/bar_att.php?id=0></td><td><img src=graphs/bar_dkphist.php?id=0></td></tr>
<tr valign=top><td>

<? include("raidlist.inc"); ?>

</td><td>

<?

// DKP Big Summary Table

$sort = 'name';

if (isset($_REQUEST['sort'])) {
	if ($_REQUEST['sort'] == 'class') {
		if (isset($_REQUEST['desc'])) {
			$sortdesc = $_REQUEST['desc'];

			if ($sortdesc == 1) {
				$sort = 'class desc, rank_id desc, available_dkp desc';
				$sortdesc = 0;
			} else {
				$sort = 'class, rank_id desc, available_dkp desc';
				$sortdesc = 1;
			}
		}
	} else if ($_REQUEST['sort'] == 'rank') {
		$sort = 'rank';
	} else if ($_REQUEST['sort'] == 'raid_count') {
		$sort = 'raid_count';
	} else if ($_REQUEST['sort'] == 'ct') {
		$sort = 'current_clock_time';
	} else if ($_REQUEST['sort'] == 'earned_dkp') {
		$sort = 'earned_dkp';
	} else if ($_REQUEST['sort'] == 'dkp_adjustment') {
		$sort = 'dkp_adjustment';
	} else if ($_REQUEST['sort'] == 'adjusted_dkp') {
		$sort = 'adjusted_dkp';
	} else if ($_REQUEST['sort'] == 'spent_dkp') {
		$sort = 'spent_dkp';
	} else if ($_REQUEST['sort'] == 'available_dkp') {
		$sort = ' available_dkp';
	} else if ($_REQUEST['sort'] == 'divisor') {
		$sort = 'divisor';
	} else if ($_REQUEST['sort'] == 'q') {
		$sort = 'q';
	} else if ($_REQUEST['sort'] == 'q1') {
		$sort = 'q1';
	} else if ($_REQUEST['sort'] == 'q2') {
		$sort = 'q2';
	}

	if (isset($_REQUEST['desc']) && $_REQUEST['sort'] != 'class') {
		$sortdesc = $_REQUEST['desc'];

		if ($sortdesc == 1) {
			$sort .= ' desc';
			$sortdesc = 0;
		} else {
			$sortdesc = 1;
		}
	}

	if (($sort != 'name') && ($sort != 'name desc')) {
		$sort .= ', name';
	}
} else {
	$sortdesc = 1;
}

$query  = "select id, name, class, rank, raid_count, current_clock_time, earned_dkp, dkp_adjustment, adjusted_dkp, spent_dkp, available_dkp, divisor, q, q1, q2 from view_agg_summary";
if (! isset($_REQUEST['allraiders']))
{
	$query .= " where current_clock_time > '00:00:00'::interval";
	$filter_raiders = '';
	$filter_link = " <font size=-1><a href=\"" . $_SERVER['PHP_SELF'] . "?allraiders=1\">[Show Inactive Raiders]</a></font> ";
} else {
	$filter_raiders = 'allraiders=1&';
	$filter_link = " <font size=-1><a href=\"" . $_SERVER['PHP_SELF'] . "\">[Hide Inactive Raiders]</a></font> ";
}
$query .= " order by $sort";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=12><font color=#FFFFFF>DKP Summary</font>" . $filter_link . "</td></tr>\n";
echo "\t<tr bgcolor=#aaaaaa>\n";

$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=name&desc=" . $sortdesc;
echo "\t\t<th>[<a href=$url>Name</a>]</th>\n";

$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=class&desc=" . $sortdesc;
echo "\t\t<th>[<a href=$url>Class</a>]</th>\n";

$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=rank&desc=" . $sortdesc;
echo "\t\t<th>[<a href=$url>Rank</a>]</th>\n";

$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=raid_count&desc=" . $sortdesc;
echo "\t\t<th>[<a href=$url>Raid Count</a>]</th>\n";

$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=ct&desc=" . $sortdesc;
echo "\t\t<th>[<a href=$url>CT</a>]</th>\n";

$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=earned_dkp&desc=" . $sortdesc;
echo "\t\t<th>[<a href=$url>Earned DKP</a>]</th>\n";

$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=dkp_adjustment&desc=" . $sortdesc;
echo "\t\t<th>[<a href=$url>Adjustments</a>]</th>\n";

$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=adjusted_dkp&desc=" . $sortdesc;
echo "\t\t<th>[<a href=$url>Adjusted DKP</a>]</th>";

if ($LD_MODE == 1) {
	$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=spent_dkp&desc=" . $sortdesc;
	echo "\t\t<th>[<a href=$url>DKP Spent</a>]</th>\n";

	$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=available_dkp&desc=" . $sortdesc;
	echo "\t\t<th>[<a href=$url>Available DKP</a>]</th></tr>\n";
} else {
	$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=divisor&desc=" . $sortdesc;
	echo "\t\t<th>[<a href=$url>Q-Divisor</a>]</th>\n";

	$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=q&desc=" . $sortdesc;
	echo "\t\t<th>[<a href=$url>Q</a>]</th>\n";

	$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=q1&desc=" . $sortdesc;
	echo "\t\t<th>[<a href=$url>Q + 1</a>]</th>\n";

	$url = $_SERVER['PHP_SELF'] . "?" . $filter_raiders . "sort=q2&desc=" . $sortdesc;
	echo "\t\t<th>[<a href=$url>Q + 2</a>]</th></tr>\n";
}

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$toon_id = array_shift($line);
	$toon_name = array_shift($line);
	$toon_class = array_shift($line);
	$toon_rank = array_shift($line);
	$raid_count = array_shift($line);
	$toon_ct = array_shift($line);
	$earned_dkp = array_shift($line);
	$dkp_adjustment = array_shift($line);
	$adjusted_dkp = array_shift($line);
	$spent_dkp = array_shift($line);
	$avail_dkp = array_shift($line);
	$divisor = array_shift($line);
	$q_value = array_shift($line);
	$q1_value = array_shift($line);
	$q2_value = array_shift($line);

	if (++$i % 2) {
		echo "\t<tr align=center>\n";
	} else {
		echo "\t<tr  align=center bgcolor=#dddddd>\n";
	}
?>
<td><a href="toon.php?id=<? print("$toon_id"); ?>"><? print("$toon_name"); ?></a></td>
<td><? print("$toon_class"); ?></td>
<td><? print("$toon_rank"); ?></td>
<td><? print("$raid_count"); ?></td>
<td><? print("$toon_ct"); ?></td>
<td align=right><? printf("%01.3f", $earned_dkp); ?></td>
<td align=right><? print("$dkp_adjustment"); ?></td>
<td align=right><? printf("%01.3f", $adjusted_dkp); ?></td>
<?
	if ($LD_MODE == 1) {
		echo "<td align=right>$spent_dkp</td>\n";
		printf("<td align=right>%01.3f</td>\n", $avail_dkp);
	} else {
		echo "<td align=right>$divisor</td>\n";
		printf("<td align=right bgcolor=#ddffdd>%01.3f</td>\n", $q_value);
		printf("<td align=right>%01.3f</td>\n", $q1_value);
		printf("<td align=right>%01.3f</td>\n", $q2_value);
	}
}

print("\t<tr bgcolor=#aaaaaa><th colspan=12>&nbsp;</th></tr>\n");
print("</table>\n");

pg_free_result($result);

pg_close($dbconn);

?>
</td></tr></table>

</body>
</html>

