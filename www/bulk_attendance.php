<?

// $Id: bulk_attendance.php,v 1.12 2006/12/04 17:39:43 mdg Exp $

require_once("common.php");

$admin_auth = 0;
if (isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ)) {
	$admin_auth = 1;
} else {
	header("Location:index.php");
	exit();
}

if (! isset($_REQUEST['id'])) {
	header("Location:index.php");
	exit();
}

$raid_id = $_REQUEST['id'];

?>

<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP - Raid</title>
</head>
<body>

<?
include('header.php');

// Process Form Requests

if (isset($_POST['raid_bulk'])) {
	$rtde = $_POST['rtde'];
	$raid_start = $_POST['raid_start'];
	$raid_stop = $_POST['raid_stop'];

	$query = "UPDATE raids set start_tstamp = '$raid_start'::timestamp, stop_tstamp = '$raid_stop'::timestamp where id = '$raid_id'";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	$query = "UPDATE attendance set first_join = '$raid_start'::timestamp where raid_id = '$raid_id' AND (first_join < '$raid_start'::timestamp OR first_join > '$raid_stop'::timestamp)";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	$query = "DELETE from waitlist_requests where raid_id = '$raid_id' AND (last_expire < '$raid_start'::timestamp OR first_request > '$raid_stop'::timestamp)";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	$query = "UPDATE waitlist_requests set first_request = '$raid_start'::timestamp where raid_id = '$raid_id' AND (first_request < '$raid_start'::timestamp)";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	$query = "UPDATE attendance set last_leave = '$raid_stop'::timestamp where raid_id = '$raid_id' AND (last_leave < '$raid_start'::timestamp OR last_leave > '$raid_stop'::timestamp)";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	$query = "UPDATE waitlist_requests set last_expire = '$raid_stop'::timestamp where raid_id = '$raid_id' AND (last_expire > '$raid_stop'::timestamp)";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	$ary_rtde = explode("\n", $rtde);

	print("<pre>\n");
	foreach($ary_rtde as $rtde_line) {

		$rtde_line = rtrim($rtde_line);

		$ary_rline = explode(",", $rtde_line);
		$raider = array_shift($ary_rline);
		$first_join = array_shift($ary_rline);
		$last_leave = array_shift($ary_rline);

		if ($last_leave == "00/00/00 00:00:00") {
			$last_leave = $raid_stop;
		}

		$query = "select id from toons where name ilike '$raider'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());

		if (pg_numrows($result) == 0) {
			pg_free_result($result);

			$query = "select nextval('public.toons_id_seq'::text)";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			$line = pg_fetch_array($result, null, PGSQL_ASSOC);
			$raider_id = array_shift($line);
			pg_free_result($result);

			$query = "INSERT into toons (id, name, class_id) values ('$raider_id', '$raider', (SELECT id from toon_classes where name ilike 'unknown'))";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);

			print("ADDED RAIDER: $raider\n");
		} else {
			$line = pg_fetch_array($result, null, PGSQL_ASSOC);
			$raider_id = array_shift($line);
			pg_free_result($result);
		}

		$query = "SELECT (('$first_join'::timestamp > '$raid_start'::timestamp) AND ('$first_join'::timestamp <= '$raid_stop'::timestamp)) as joined_late, (('$last_leave'::timestamp < '$raid_stop'::timestamp) AND ('$last_leave'::timestamp >= '$raid_start'::timestamp)) as left_early, (count(*) > 0) as existing_record from attendance where raid_id = '$raid_id' AND toon_id = '$raider_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		$line = pg_fetch_array($result, null, PGSQL_ASSOC);

		$joined_late = array_shift($line);
		$left_early = array_shift($line);
		$existing_record = array_shift($line);

		pg_free_result($result);

		if ($joined_late == 'f') {
			$first_join = $raid_start;
		}

		if ($left_early == 'f') {
			$last_leave = $raid_stop;
		}

		if ($existing_record == 't') {
			$query = "UPDATE attendance set first_join = '$first_join'::timestamp, last_leave = '$last_leave'::timestamp where raid_id = '$raid_id' AND toon_id = '$raider_id'";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);
		} else {
			$query = "INSERT into attendance (raid_id, toon_id, first_join, last_leave) VALUES ('$raid_id', '$raider_id', '$first_join'::timestamp, '$last_leave'::timestamp)";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);
		}

		$query = "DELETE from waitlist_requests where raid_id = '$raid_id' and toon_id = '$raider_id' and (first_request > '$first_join'::timestamp)";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);

		$query = "UPDATE waitlist_requests set last_expire = '$first_join'::timestamp where raid_id = '$raid_id' and toon_id = '$raider_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
	}

	$query = "UPDATE waitlist_requests set approved = 't' where raid_id = '$raid_id'";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	print("</pre>\n");
	print("<center><h1>Raid Attendance Updated</h1></center>\n");
}

?>
<center><a href="raid.php?id=<? print($raid_id); ?>">[Back to Raid Detail]</a></center>
<form method=POST><table align=center><tr valign=top><td>
<?

// Raid Detail Table

$query = "SELECT dungeon, dungeon_id, raid_date, raid_start, raid_stop FROM view_raids where id = '$raid_id'";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

echo "<table border=0 cellspacing=0 align=center>\n";
echo "<tr bgcolor=#000000><td colspan=2><font color=#FFFFFF>Raid Detail</font></td></tr>\n";
echo "<tr bgcolor=#aaaaaa><td colspan=2 align=center><font color=#FF0000>Valid Start and Stop times on this form REQUIRED<br>(YYYY-MM-DD 24:mm:ss)</font></td></tr>\n";

$line = pg_fetch_array($result, null, PGSQL_ASSOC);
$raid_dungeon = array_shift($line);
$raid_dungeon_id = array_shift($line);
$raid_date = array_shift($line);
$raid_start = array_shift($line);
$raid_stop = array_shift($line);
pg_free_result($result);

?>
<tr><th align=right>Dungeon: </th><td align=left><? print($raid_dungeon); ?></td></tr>
<tr bgcolor=#dddddd><th align=right>Date: </th><td align=left><? print($raid_date); ?></td></tr>
<?
$not_started_yet = $not_stopped_yet = 0;

if ($raid_start == '') {
	$not_started_yet = 1;
	$raid_start = 'Not Started Yet';
}
if ($raid_stop == '') {
	$not_stopped_yet = 1;
	$raid_stop = 'Not Stopped Yet';
}

echo "<tr><th align=right>Clock Started: </th><td align=left><input type=textbox name=raid_start value='$raid_start'></td></tr>\n";
echo "<tr bgcolor=#dddddd><th align=right>Clock Stopped: </th><td align=left><input type=textbox name=raid_stop value='$raid_stop'></td></tr>\n";

?>
<tr bgcolor=#aaaaaa><td align=center colspan=2><input type=submit name=raid_bulk value="Ready! Record Attendance"> <input type=reset></td></tr>
</table>

</td><td>
<?


// Attendance Table

echo "<table border=0 cellspacing=0 align=center>\n";
echo "<tr bgcolor=#000000><td><font color=#FFFFFF>Attendance</font></td></tr>\n";
echo "<tr bgcolor=#aaaaaa><td><ul><li>Paste the output from rtde.pl for this raid here</li><li>ONLY use <a href='http://www.curse-gaming.com/mod.php?addid=3236' target='_BLANK'>rtde version 0.51</a></li><li>Times listed here are authoritative</li><li>Unrecognized raiders will be automatically added</li><li>Start Time will be set to the Raid Start or First Join, whichever is later</li><li>Stop Time will be set to the Raid Stop or Last Leave, whichever is earlier</li></ul></td></tr>\n";

print("<tr bgcolor=#aaaaaa><td align=center><textarea name=rtde rows=30 cols=60></textarea></td></tr>\n");
print("<tr bgcolor=#aaaaaa><td>&nbsp;</td></tr>\n");
print("</table></form>\n");

pg_close($dbconn);

?>
</td></tr></table>

</body>
</html>
