<?

// $Id: toon.php,v 1.13 2006/12/04 17:39:44 mdg Exp $

require_once("common.php");

if (! isset($_REQUEST['id'])) {
	header("Location:index.php");
	exit();
}

$toon_id = $_REQUEST['id'];

if ($toon_id < 0) {
	header("Location:index.php");
	exit();
}
?>

<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP - Raider</title>
</head>
<body>

<?
include('header.php');

// Process Form Requests

$admin_auth = 0;
if (isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ)) {
	$admin_auth = 1;
}

if (isset($_POST['update_alt'])) {
	$toon_alt = $_POST['alt_status'];

	if ($toon_alt == 't' || $toon_alt == 'f') {
		$query = "UPDATE toons set alt = '$toon_alt' where id = '$toon_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
		print("<center><h1>Raider Updated</h1></center>\n");
	}
}

if ($admin_auth) {
	if (isset($_POST['toon_mod'])) {
		$toon_name = $_POST['toon_name'];
		$toon_class = $_POST['toon_class'];
		$toon_rank = $_POST['toon_rank'];

		$query = "UPDATE toons set name = '$toon_name', class_id = '$toon_class', rank_id = '$toon_rank' where id = '$toon_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
		print("<center><h1>Raider Updated</h1></center>\n");
	}

	if (isset($_POST['adj_add'])) {
		$adj_date = $_POST['adj_date'];
		$dkp_adj = $_POST['dkp_adj'];
		$qdiv_adj = $_POST['qdiv_adj'];
		$ct_adj = $_POST['ct_adj'];
		$adj_reason = $_POST['adj_reason'];

		$query = "INSERT into dkp_adjustments (toon_id, value, adj_date, reason, item_value, ct_value) values ('$toon_id', '$dkp_adj', '$adj_date', '$adj_reason', '$qdiv_adj', '$ct_adj')";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
	}

	if (isset($_POST['stop_raid_ct'])) {
		$raid_id = $_POST['raid_id'];

		$query = "UPDATE attendance set last_leave = now() where toon_id = '$toon_id' and raid_id = '$raid_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
	}
}

?>
<table width=100% align=center valign=center cellspacing=0><tr><td colspan=2>
<?
echo "<table border=0 width=100%><tr bgcolor=#ffffff valign=center><td width=33% align=center><img src=graphs/bar_att.php?id=$toon_id></td><td width=33% align=center>\n";

// Toon Detail Table

$query = "select name, class, rank, current_clock_time, alt from view_agg_summary where id = '$toon_id'";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

echo "<table border=0 cellspacing=0 align=center>\n";
echo "<tr bgcolor=#000000><td colspan=2><font color=#FFFFFF>Raider Detail</font></td></tr>\n";

$line = pg_fetch_array($result, null, PGSQL_ASSOC);
$toon_name = array_shift($line);
$toon_class = array_shift($line);
$toon_rank = array_shift($line);
$toon_ct = array_shift($line);
$toon_alt = array_shift($line);
pg_free_result($result);

echo "<tr bgcolor=#aaaaaa><th align=right>ALT?</th><td align=left><form method=POST><select name=alt_status>";
if ($toon_alt == 't') {
	echo "<option value='t' SELECTED>Yes</option><option value='f'>No</option>";
} else {
	echo "<option value='t'>Yes</option><option value='f' SELECTED>No</option>";
}
echo "</select> <input type=submit name=update_alt value='Update'></form></th></tr>\n";

$query = 'SELECT id, name FROM toon_classes order by name';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
?>
<tr><th align=right>Name: </th><td align=left><form method=POST><input type=textbox name=toon_name value="<? print($toon_name); ?>"></td></tr>
<tr bgcolor=#dddddd><th align=right>Class: </th><td align=left><select name=toon_class>
<?
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
        $class_id = array_shift($line);
        $class_name = array_shift($line);

        echo "\t<option value=$class_id";
	if ($class_name == $toon_class) {
		print(" SELECTED");
	}
	echo ">$class_name</option>\n";
}
echo "</select></td></tr>\n";
pg_free_result($result);

$query = 'SELECT id, name FROM toon_ranks order by id';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
?>
<tr><th align=right>Rank: </th><td align=left><select name=toon_rank>
<?
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
        $rank_id = array_shift($line);
        $rank_name = array_shift($line);

        echo "\t<option value=$rank_id";
	if ($rank_name == $toon_rank) {
		print(" SELECTED");
	}
	echo ">$rank_name</option>\n";
}
echo "</select></td></tr>\n";
pg_free_result($result);

echo "<tr bgcolor=#dddddd><th align=right>Clock Time: </th><td align=left>$toon_ct</td></tr>\n";

if ($admin_auth) {
?>
<tr bgcolor=#aaaaaa><td align=center colspan=2><input type=submit name=toon_mod value="Modify Raider Detail"> <input type=reset></td></tr>
<?
} else {
?>
<tr bgcolor=#aaaaaa><td colspan=2>&nbsp;</td></tr>
<?
}
?>
</form>
</table>

</td><td><img src="graphs/bar_dkphist.php?id=<? print($toon_id); ?>"></td></tr></table></td></tr>
<tr valign=top><td>
<?


// Clock Time Table

$query = "SELECT curr_raid, curr_waitlist, curr_adjust, curr_raid + curr_waitlist + curr_adjust as curr_total, exp_raid, exp_waitlist, exp_adjust, exp_raid + exp_waitlist + exp_adjust as exp_total, all_raid, all_waitlist, all_adjust, all_raid + all_waitlist + all_adjust as all_total from view_ct_summary where id = '$toon_id'";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$line = pg_fetch_array($result, null, PGSQL_ASSOC);

$curr_raid = array_shift($line);
$curr_waitlist = array_shift($line);
$curr_adjust = array_shift($line);
$curr_total = array_shift($line);
$exp_raid = array_shift($line);
$exp_waitlist = array_shift($line);
$exp_adjust = array_shift($line);
$exp_total = array_shift($line);
$all_raid = array_shift($line);
$all_waitlist = array_shift($line);
$all_adjust = array_shift($line);
$all_total = array_shift($line);

pg_free_result($result);

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=5><font color=#FFFFFF>Clock Time</font></td></tr>\n";
echo "<tr bgcolor=#aaaaaa><th>&nbsp;</th><th>[In-Raid]</th><th>[Waitlist]</th><th>[Adjusted]</th><th>[Total]</th></tr>\n";
echo "<tr align=center><th bgcolor=#aaaaaa>[Current]</th><td>$curr_raid</td><td>$curr_waitlist</td><td>$curr_adjust</td><td bgcolor=#dddddd><font color=green><b>$curr_total</b></font></td></tr>\n";
echo "<tr align=center><th bgcolor=#aaaaaa>[Expired]</th><td>$exp_raid</td><td>$exp_waitlist</td><td>$exp_adjust</td><td bgcolor=#dddddd>$exp_total</td></tr>\n";
echo "<tr bgcolor=#dddddd align=center><th bgcolor=#aaaaaa>[Totals]</th><td>$all_raid</td><td>$all_waitlist</td><td>$all_adjust</td><td>$all_total</td></tr>\n";
echo "</table>\n<br>\n";


// Attendance History Table

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=5><font color=#FFFFFF>Attendance History</font></td></tr>\n";
echo "<tr bgcolor=#aaaaaa><th>[Date]</th><th>[Dungeon]</th><th>[Value]</th>";

echo "<th>[CT / Raid Length]</th><th>[DKP Earned]</th>";

echo "</tr>\n";

$query = "SELECT va.raid_id, va.dungeon, va.raid_date, va.value, va.clock_time, va.raid_length, va.earned_dkp from view_attendance va where toon_id = '$toon_id' order by raid_date desc";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$numrows = pg_numrows($result);
if ($numrows == 0) {
	print("\t<tr><td align=center colspan=5><font color=red>No Raid Attendance on Record</font></td></tr>\n");
} else {
	$i = 0;
	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$raid_id = array_shift($line);
		$raid_dungeon = array_shift($line);
		$raid_date = array_shift($line);
		$raid_value = array_shift($line);
		$raid_ct = array_shift($line);
		$raid_length = array_shift($line);
		$raid_earned_dkp = array_shift($line);

		if (++$i % 2) {
			print("\t<tr align=center>\n");
		} else {
			print("\t<tr align=center bgcolor=#dddddd>\n");
		}

		print("\t<td><a href=\"raid.php?id=$raid_id\">$raid_date</td>\n");
		print("\t<td>$raid_dungeon</td>\n");
		print("\t<td align=right>$raid_value</td>\n");
		if (($raid_ct == '') && ($raid_length == '')) {
			if ($admin_auth) {
				print("\t<td colspan=2><form method=POST><input type=hidden name=raid_id value='$raid_id'><input type=submit name=stop_raid_ct value='Left Raid'></form></td>\n");
			} else {
				print("\t<td colspan=2>Raid Still Active</td>\n");
			}
		} else if ($raid_length == '') {
			print("\t<td>$raid_ct</td>\n");
			print("\t<td>&nbsp;</td>\n");
		} else {
			print("\t<td>$raid_ct / $raid_length</td>\n");
			printf("\t<td align=right>%01.3f</td>\n", $raid_earned_dkp);
		}
		print("</tr>\n");
	}

	pg_free_result($result);

	print("</tr>\n");
}

print("<tr bgcolor=#aaaaaa><td colspan=5>&nbsp;</td></tr>\n");
print("</table>\n");

?>
</td><td>
<?

// Adjustment History Table

$today = date("Y-m-d");

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=5><font color=#FFFFFF>Adjustment History</font></td></tr>\n";

print("<tr bgcolor=#aaaaaa><th>[Date]</th><th>[DKP Adj]</th>");

if ($LD_MODE == 2) {
	print("<th>[Q-Divisor Adj]</th>");
}

print("<th>[CT Adj]</th>");

print("<th>Reason</th></tr>\n");

if ($admin_auth) {
	print("<form method=POST><tr bgcolor=#aaaaaa align=center><td><input type=textbox name=adj_date value=$today></td><td><input type=textbox name=dkp_adj value=0>");

	if ($LD_MODE == 1) {
		print("<input type=hidden name=qdiv_adj value=0></td>");
	} else {
		print("</td><td><input type=textbox name=qdiv_adj value=0></td>");
	}

	print("<td><input type=textbox name=ct_adj value='00:00:00'></td>");

	print("<td><input type=textbox name=adj_reason value=Reason></td></tr>\n");
	print("<tr bgcolor=#aaaaaa align=center><td colspan=5><input type=submit name=adj_add value='Add Adjustment'> <input type=reset></td></tr></form>\n");
}

$query = "SELECT adj_date, value as dkp_adj, item_value as qdiv_adj, ct_value as ct_adj, reason from dkp_adjustments where toon_id = '$toon_id' order by adj_date desc";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$toon_adj_date = array_shift($line);
	$toon_dkp_adj = array_shift($line);
	$toon_qdiv_adj = array_shift($line);
	$toon_ct_adj = array_shift($line);
	$toon_adj_reason = array_shift($line);

	if (++$i % 2) {
		print("\t<tr align=center>\n");
	} else {
		print("\t<tr align=center bgcolor=#dddddd>\n");
	}

	print("\t\t<td>$toon_adj_date</td>\n");
	print("\t\t<td>$toon_dkp_adj</td>\n");

	if ($LD_MODE == 2) {
		print("\t\t<td>$toon_qdiv_adj</td>\n");
	}

	print("\t\t<td>$toon_ct_adj</td>\n");

	print("\t\t<td align=center>$toon_adj_reason</td>\n");
	print("\t</tr>\n");
}

print("<tr bgcolor=#aaaaaa><td colspan=5>&nbsp;</td></tr></table>\n");

?>
<br><center><img src="graphs/bar_dkphist_byloc.php?id=<? print($toon_id); ?>"></center><br>
<?

// Item History Table

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=5><font color=#FFFFFF>Item History</font></td></tr>\n";
print("<tr bgcolor=#aaaaaa><th>[Date]</th><th>[Dungeon]</th><th>[Item]</th>");

if ($LD_MODE == 1) {
	print("<th>[Default Cost]</th><th>[Purchase Price]</th>");
}

print("</tr>\n");

$query = "SELECT r.dungeon, r.raid_date, l.raid_id, l.item_name, l.item_id, l.default_value, l.value from view_loot l, view_raids r where l.toon_id = '$toon_id' and l.raid_id = r.id order by raid_date, item_name";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
$red_items = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$item_dungeon = array_shift($line);
	$item_date = array_shift($line);
	$item_raidid = array_shift($line);
	$item_name = array_shift($line);
	$item_id = array_shift($line);
	$item_default_value = array_shift($line);
	$item_value = array_shift($line);

	if (++$i % 2) {
		print("\t<tr align=center>\n");
	} else {
		print("\t<tr align=center bgcolor=#dddddd>\n");
	}

	print("\t\t<td><a href=\"raid.php?id=$item_raidid\">$item_date</a></td>\n");
	print("\t\t<td>$item_dungeon</td>\n");
	print("\t\t<td><a href=\"item.php?id=$item_id\">$item_name</a></td>\n");

	if ($LD_MODE == 1) {
		print("\t\t<td align=right>$item_default_value</td>\n");
		if ($item_value != $item_default_value) {
			print("\t\t<td align=right><font color=red>$item_value</font></td>\n");
			$red_items = 1;
		} else {
			print("\t\t<td align=right>$item_value</td>\n");
		}
	}

	print("\t</tr>\n");
}

if ($red_items) {
	print("<tr align=center><td colspan=5><font size=-1 color=red>* Red items indicate DKP values that are inconsistent with the <b>current</b> default DKP value for that item</font></td></tr>\n");
}

print("<tr bgcolor=#aaaaaa><td colspan=5>&nbsp;</td></tr></table>\n");

pg_close($dbconn);

?>

</td></tr></table>


</body>
</html>
