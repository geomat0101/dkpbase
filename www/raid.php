<?

// $Id: raid.php,v 1.16 2006/08/29 15:20:17 mdg Exp $

require_once("common.php");

if (! isset($_REQUEST['id'])) {
	header("Location:index.php");
	exit();
}

$raid_id = $_REQUEST['id'];

?>

<html>
<head>
	<title>DKP - Raid</title>
</head>
<body>

<?
include('header.php');

// Process Form Requests

$admin_auth = 0;
if (isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ)) {
	$admin_auth = 1;
}

if ($admin_auth) {
	if (isset($_POST['raid_mod'])) {
		$raid_date = $_POST['raid_date'];

		// STATIC dungeons always pass raid_value, KILLBASED dungeons pass raid_kills (empty if no kills selected on form)
		if (isset($_POST['raid_value'])) {
			$raid_value = $_POST['raid_value'];

			$query = "UPDATE raids set raid_date = '$raid_date', value = '$raid_value' where id = '$raid_id'";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);
		} else {
			if (!($_POST['raid_kills'])) {
				// no kills posted, delete em all
				$query = "DELETE from raid_kills where raid_id = '$raid_id'";
				$result = pg_query($query) or die('Query failed: ' . pg_last_error());
				pg_free_result($result);
			} else {
				// get rid of kill records that are pre-existing but not in the current request
				$raid_kills = $_POST['raid_kills'];
				$user_kills = implode(", ", $raid_kills);

				$query = "DELETE from raid_kills where raid_id = '$raid_id' AND boss_id not in ($user_kills)";
				$result = pg_query($query) or die('Query failed: ' . pg_last_error());
				pg_free_result($result);

				// get remaining list of kills from db
				$query = "SELECT boss_id from raid_kills where raid_id = '$raid_id' order by boss_id";
				$result = pg_query($query) or die('Query failed: ' . pg_last_error());
				$db_kills = array();
				while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
					array_push($db_kills, array_shift($line));
				}
				pg_free_result($result);
	
				// iterate through user submission, add new records if they don't exist already
				foreach ($raid_kills as $user_kill) {
					$found = 0;
					foreach ($db_kills as $db_kill) {
						if ($db_kill == $user_kill) {
							$found = 1;
							break;
						}
					}

					if ($found == 0) {
						$query = "INSERT into raid_kills (raid_id, boss_id, value) values ('$raid_id', '$user_kill', (select value from dungeon_bosses where id = '$user_kill'))";
						$result = pg_query($query) or die('Query failed: ' . pg_last_error());
						pg_free_result($result);
					}
				}
			}

			// update raid_date and raid_value
			$query = "UPDATE raids set raid_date = '$raid_date', value = (select coalesce(sum(value), 0) from raid_kills where raid_id = '$raid_id') where id = '$raid_id'";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);
		}

		print("<center><h1>Raid Updated</h1></center>\n");
	}


	if (isset($_POST['raid_start_ct'])) {
// XXX Because of the way the form gets used, the start button will not update the waitlist first_request to the raid start time
//     The bulk entry form DOES do this, so it should probably be required that admins enter attendance using that interface
		$query = "UPDATE raids set start_tstamp = now() where id = '$raid_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);

		$query = "UPDATE attendance set first_join = now(), last_leave = NULL where raid_id = '$raid_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
	}
	
	if (isset($_POST['raid_stop_ct'])) {
		$query = "UPDATE raids set stop_tstamp = now() where id = '$raid_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);

		$query = "UPDATE attendance set last_leave = now() where raid_id = '$raid_id' and last_leave IS NULL";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);

		$query = "UPDATE waitlist_requests set last_expire = now() where raid_id = '$raid_id' and last_expire > now()";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
	}

	// Items
	if (isset($_POST['item_add'])) {
		$item_toon = $_POST['item_toon'];
		$item_id = $_POST['item_id'];
		$item_value_override = 0;
		if (isset($_POST['item_value_override'])) {
			$item_value_override = 1;
		}
		$item_value = $_POST['item_value'];

		if ($item_toon == -1) {
			$query = "UPDATE items set bank_inventory = (bank_inventory + 1) where id = '$item_id'";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);
		}

		if ($item_value_override) {
			$query = "INSERT into loot (raid_id, toon_id, item_id, value) values ('$raid_id', '$item_toon', '$item_id', '$item_value')";
		} else {
			$query = "INSERT into loot (raid_id, toon_id, item_id, value) values ('$raid_id', '$item_toon', '$item_id', (select value from items where id = '$item_id'))";
		}

		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
	}


	// Attendance
	if (isset($_POST['att_mod'])) {
		if (!($_POST['raid_att'])) {
			// no attendees posted, delete em all
			$query = "DELETE from attendance where raid_id = '$raid_id'";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);
		} else {
			// get rid of records that are pre-existing but not in the current request
			$raid_att = $_POST['raid_att'];
			$user_att = implode(", ", $raid_att);

			$query = "DELETE from attendance where raid_id = '$raid_id' AND toon_id not in ($user_att)";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);

			// get remaining list of attendees from db
			$query = "SELECT toon_id from attendance where raid_id = '$raid_id' order by toon_id";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			$db_atts = array();
			while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
				array_push($db_atts, array_shift($line));
			}
			pg_free_result($result);

			// iterate through user submission, add new records if they don't exist already
			foreach ($raid_att as $user_att) {
				$found = 0;
				foreach ($db_atts as $db_att) {
					if ($db_att == $user_att) {
						$found = 1;
						break;
					}
				}

				if ($found == 0) {
					$query = "INSERT into attendance (raid_id, toon_id, first_join) values ('$raid_id', '$user_att', now())";
					$result = pg_query($query) or die('Query failed: ' . pg_last_error());
					pg_free_result($result);
				}
			}
		}

		print("<center><h1>Raid Updated</h1></center>\n");
	}

	if (isset($_POST['waitlist_fired'])) {
		$fired_toon = $_POST['toon_id'];
		$fired_raid = $_POST['raid_id'];

		$query = "UPDATE waitlist_requests set last_expire = (now() - '1 second'::interval) where toon_id = '$fired_toon' and raid_id = '$fired_raid' and last_expire > now()";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
	}
}


// Raid Detail Table

$query = "SELECT dungeon, content_tier, dungeon_id, raid_date, value, dkp_type, raid_start, raid_stop, raid_length FROM view_raids where id = '$raid_id'";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

echo "<form method=POST>\n";
echo "<table border=0 cellspacing=0 align=center>\n";
echo "<tr bgcolor=#000000><td colspan=2><font color=#FFFFFF>Raid Detail</font></td></tr>\n";
echo "<tr bgcolor=#aaaaaa><td colspan=2>&nbsp;</td></tr>\n";

$line = pg_fetch_array($result, null, PGSQL_ASSOC);
$raid_dungeon = array_shift($line);
$raid_content_tier = array_shift($line);
$raid_dungeon_id = array_shift($line);
$raid_date = array_shift($line);
$raid_value = array_shift($line);
$raid_dkp_type = array_shift($line);
$raid_start = array_shift($line);
$raid_stop = array_shift($line);
$raid_length = array_shift($line);
pg_free_result($result);

?>
<tr><th align=right>Dungeon: </th><td align=left><? print($raid_dungeon); ?></td></tr>
<tr bgcolor=#dddddd><th align=right>Date: </th><td align=left><input type=textbox name=raid_date value="<? print($raid_date); ?>"></td></tr>
<?

$not_started_yet = $not_stopped_yet = 0;

if ($raid_start == '') {
	$not_started_yet = 1;
	$raid_start = 'Not Started Yet';
}
if ($raid_stop == '') {
	$not_stopped_yet = 1;
	$raid_stop = 'Not Stopped Yet';
	$raid_length = 'Raid Still Active';
}

echo "<tr><th align=right>Clock Started: </th><td align=left>$raid_start</td></tr>\n";
echo "<tr bgcolor=#dddddd><th align=right>Clock Stopped: </th><td align=left>$raid_stop</td></tr>\n";
echo "<tr><th align=right>Raid Length: </th><td align=left>$raid_length</td></tr>\n";

?>
<tr bgcolor=#dddddd><th align=right>Max DKP Value: </th><td align=left>
<?

if ($raid_dkp_type == 'STATIC') {
	echo "<input type=textbox name=raid_value value=\"$raid_value\">\n";
} else if ($raid_dkp_type == 'KILLBASED') {
	$db_kills = array();
	$query = "SELECT boss_id, value from raid_kills where raid_id = '$raid_id' order by boss_id";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$db_id = array_shift($line);
		$db_kills[$db_id] = array_shift($line);
	}
	pg_free_result($result);

	$query = "SELECT id, name, value from dungeon_bosses order by name";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	$numrows = pg_numrows($result);
	if ($numrows == 0) {
		print("<font color=red>No Bosses Defined for $raid_dungeon</font>\n");
	} else {
		$cols = ceil(sqrt($numrows));
		$i = 0;
		$red_items = 0;
		echo "<table align=center width=100%><tr>\n";
		while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
			$boss_id = array_shift($line);
			$boss_name = array_shift($line);
			$boss_value = array_shift($line);

			echo "\t\t<td><input type=checkbox name=raid_kills[$i] value=$boss_id";
			if (isset($db_kills[$boss_id])) {
				echo " CHECKED";
			}

			if (isset($db_kills[$boss_id]) && ($db_kills[$boss_id] != $boss_value)) {
				echo "> $boss_name (<font color=red>$db_kills[$boss_id]</font>)</td>\n";
				$red_items = 1;
			} else {
				echo "> $boss_name ($boss_value)</td>\n";
			}

			if ((++$i % $cols) == 0) {
				echo "\t</tr><tr>\n";
			}
		}
		echo "</tr></table>\n";

		if ($red_items) {
			echo "<br><font size=-1 color=red>* Red items indicate DKP awards that are inconsistent with the <b>current</b> default DKP value for that boss</font>\n";
		}
	}
	pg_free_result($result);
}

echo "</td></tr>\n";

if ($admin_auth) {
?>
<tr bgcolor=#aaaaaa><td align=center colspan=2><input type=submit name=raid_mod value="Modify Raid Detail"> <input type=reset></td></tr>
<?
} else {
?>
<tr bgcolor=#aaaaaa><td colspan=2>&nbsp;</td></tr>
<?
}
?>
</form>
</table>

<hr width=30%>
<?

if ($admin_auth && ($not_started_yet || $not_stopped_yet)) {
	echo "<table border=0 cellspacing=0 align=center>\n";
	echo "<tr bgcolor=#000000><td><font color=#FFFFFF>Clock Time</font></td></tr>\n";
	echo "<tr bgcolor=#dddddd><td align=center>";

	if ($not_started_yet) {
		echo "<form method=POST><input type=submit name=raid_start_ct value='Start Raid Clock'></form> ";
	} else if ($not_stopped_yet) {
		echo "<form method=POST><input type=submit name=raid_stop_ct value='Stop Raid Clock'></form> ";
	}

	echo "</td></tr></table>\n";
	echo "<hr width=30%>\n";
}


// Item Table

echo "<form method=POST><table border=0 cellspacing=0 align=center>\n";
echo "<tr bgcolor=#000000><td colspan=4><font color=#FFFFFF>Items</font></td></tr>\n";
if ($admin_auth) {
	echo "<tr bgcolor=#aaaaaa><td align=center colspan=4><select name=item_toon><option value=0 SELECTED>Choose Raider</option><option value=-1>*** BANK ***</option>\n";

	$query = "SELECT toon_id, name FROM view_attendance where raid_id = '$raid_id' order by name";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$toon_id = array_shift($line);
		$toon_name = array_shift($line);

		print("\t<option value=$toon_id>$toon_name</option>\n");
	}

	pg_free_result($result);

	print("</select> <select name=item_id><option value=0 SELECTED>Choose Item</option\n");

	$query = "SELECT id, name || ' (' || value || ')' as item FROM items where dungeon_id ISNULL OR dungeon_id in (select dungeon_id from raids where id = '$raid_id') order by name";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$item_id = array_shift($line);
		$item_desc = array_shift($line);

		print("\t<option value=$item_id>$item_desc</option>\n");
	}

	pg_free_result($result);

	print("</select><br><input type=checkbox name=item_value_override> Override Default Value <input type=textbox name=item_value value=\"New Value\"><br><input type=submit name=item_add value=\"Add Item\"> <input type=reset></td></tr></form>\n");
}
print("<tr bgcolor=#aaaaaa><th>[Raider]</th><th>[Item]</th>");

if ($LD_MODE == 1) {
	print("<th>[Default Cost]</th><th>[Purchase Price]</th>");
}

print("</tr>\n");

$query = "SELECT toon_name, toon_id, item_name, item_id, default_value, value from view_loot where raid_id = '$raid_id' order by item_name, toon_name";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
$red_items = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$item_toon = array_shift($line);
	$item_toonid = array_shift($line);
	$item_name = array_shift($line);
	$item_id = array_shift($line);
	$item_default_value = array_shift($line);
	$item_value = array_shift($line);

	if (++$i % 2) {
		print("\t<tr align=center>\n");
	} else {
		print("\t<tr align=center bgcolor=#dddddd>\n");
	}

	if ($item_toonid > 0) {
		print("\t\t<td><a href=\"toon.php?id=$item_toonid\">$item_toon</a></td>\n");
	} else {
		print("\t\t<td>$item_toon</td>\n");
	}
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
	print("<tr align=center><td colspan=4><font size=-1 color=red>* Red items indicate DKP values that are inconsistent with the <b>current</b> default DKP value for that item</font></td></tr>\n");
}

print("<tr bgcolor=#aaaaaa><td colspan=4>&nbsp;</td></tr></table>\n");
print("<hr width=30%>\n");


// Attendance Table

$class_colors = array(
	'Shaman' => '#FF69B4',
	'Hunter' => 'lime',
	'Warlock' => '#5B1092',
	'Mage' => 'aqua',
	'Druid' => '#FF8500',
	'Priest' => 'white',
	'Rogue' => 'yellow',
	'Warrior' => '#8B4513',
	'Unknown' => 'silver'
);

$rank_colors = array(
	5 => '#000000',
	4 => '#222222',
	3 => '#444444',
	2 => '#666666',
	1 => '#888888'
);

echo "<table border=0 cellspacing=0 align=center>\n";
echo "<tr bgcolor=#000000><td><font color=#FFFFFF>Attendance</font> ";

if ($admin_auth) {
	echo "<font size=-1><a href='bulk_attendance.php?id=$raid_id'>[Bulk Entry]</a></font>";
}

echo "</td></tr>\n";
if ($admin_auth) {
	if ($not_stopped_yet == 0) {
		echo "<tr bgcolor=#aaaaaa><td align=center><font size=-1 color=red>The clock on this raid has been stopped.  Attendance may only be modified via bulk entry.</font></td></tr>\n";
	} else {
		echo "<form method=POST><tr bgcolor=#aaaaaa><td align=center><input type=submit name=att_mod value=\"Update Attendees\"> <input type=reset></td></tr>\n";
	}
}
echo "<tr bgcolor=#aaaaaa><td>In Raid</td></tr>\n";

$query = "SELECT va.toon_id, va.name, tc.name as class, va.first_join, va.last_leave, va.clock_time, va.earned_dkp FROM view_attendance va, toons t, toon_classes tc where va.raid_id = '$raid_id'  and va.toon_id = t.id and t.class_id = tc.id order by name";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$numrows = pg_numrows($result);
if ($numrows == 0) {
	print("\t<tr><td align=center><font color=red>No Attendees Selected for Raid</font></td></tr>\n");
} else if ($not_stopped_yet == 0) {
	print("<tr><td align=center><a href=\"graphs/gantt_roster.php?id=$raid_id\"><img border=0 src=\"graphs/gantt_roster.php?id=$raid_id\"></a></td></tr>\n");
} else {
	$cols = ceil(sqrt($numrows));
	$i = 0;

	print("<tr><td><table width=100% bgcolor=#000000 cellspacing=1><tr>\n");
	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$toon_dbid = array_shift($line);
		$toon_name = array_shift($line);
		$toon_class = array_shift($line);

		$my_color = $class_colors[$toon_class];
		print("\t<td><input type=checkbox name=raid_att[$i] value=$toon_dbid CHECKED> <a href='toon.php?id=$toon_dbid'><font color='$my_color'>$toon_name</font></a></td>\n");

		if ((++$i % $cols) == 0) {
			print("</tr><tr>\n");
		}
	}


	print("</tr></table></td></tr>\n");
}

pg_free_result($result);

echo "<tr bgcolor=#aaaaaa><td>Waiting List</td></tr>\n";

$query = "SELECT toon_id, toon, class, first_request, last_expire, (last_expire < now()) as expired, clock_time, approved FROM view_waitlist where raid_id = '$raid_id' order by expired, first_request";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

echo "\t<tr><td><table width=100% border=1>\n";
echo "\t\t<tr bgcolor=#dddddd><th>Name</th><th>Class</th><th>First Request</th><th>Last Expire</th><th>Time on List</th><th>Approved</th></tr>\n";

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$toon_dbid = array_shift($line);
	$toon_name = array_shift($line);
	$toon_class = array_shift($line);
	$toon_first_request = array_shift($line);
	$toon_last_expire = array_shift($line);
	$toon_req_expired = array_shift($line);
	$toon_ct = array_shift($line);
	$toon_req_approved = array_shift($line);

	if (++$i % 2) {
		print("\t<tr align=center>\n");
	} else {
		print("\t<tr bgcolor=#dddddd align=center>\n");
	}

	print("\t\t<td><a href='toon.php?id=$toon_dbid'>$toon_name</a></td>\n");
	print("\t\t<td>$toon_class</td>\n");
	print("\t\t<td>$toon_first_request</td>\n");
	if ($toon_req_expired == 'f') {
		print("\t\t<td bgcolor=#aaffaa>$toon_last_expire</td>\n");
	} else {
		print("\t\t<td bgcolor=#ffaaaa>$toon_last_expire</td>\n");
	}
	print("\t\t<td>$toon_ct</td>\n");
	if ($admin_auth && ($toon_req_expired == 'f')) {
		print("\t\t<td><form method=POST><input type=hidden name=raid_id value='$raid_id'><input type=hidden name=toon_id value='$toon_dbid'><input type=submit name=waitlist_fired value='FIRED!'></form></td>\n");
	} else {
		print("\t\t<td>$toon_req_approved</td>\n");
	}
	print("\t</tr>\n");
}

print("</table></td></tr>\n");

pg_free_result($result);

echo "<tr bgcolor=#aaaaaa><td>Not In Raid</td></tr>\n";

$query = "SELECT id, name, class, rank_id, current_clock_time FROM view_agg_summary where id not in (select toon_id from attendance where raid_id = '$raid_id') and current_clock_time > '00:00:00' order by class, rank_id desc, current_clock_time desc";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$numrows = pg_numrows($result);
if ($numrows == 0) {
	print("\t<tr><td align=center><font color=red>All Raiders Selected as Attendees</font></td></tr>\n");
} else {
	$cols = ceil(sqrt($numrows));

	if ($not_stopped_yet) {
		print("\t<tr><td align=center valign=top>");
		print("<table width=100% height=100%>");
		print("\t<tr><td colspan=3><table width=100%><tr align=center><td bgcolor=#888888><font color=#ffffff>New Raider</font></td><td bgcolor=#666666><font color=#ffffff>Tier-1 Raider</font></td><td bgcolor=#444444><font color=#ffffff>Tier-1 Veteran</font></td><td bgcolor=#222222><font color=#ffffff>Boddhisatva</font></td><td bgcolor=#000000><font color=#ffffff>Roshi</font></td></tr></table></td></tr>\n");
		print("\t<tr><td>\n");

		$j = 0;
		$current_class = '';
		while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
			$toon_dbid = array_shift($line);
			$toon_name = array_shift($line);
			$toon_class = array_shift($line);
			$toon_rank_id = array_shift($line);
			$toon_ct = array_shift($line);

			if ($current_class != $toon_class) {
				$current_class = $toon_class;

				if ($j > 0) {
					print("</table></td>");

					if (($j++ % 3) == 0) {
						print("</tr><tr>");
					}

					print("<td>\n");
				} else {
					$j++;
				}

				print("<table width=100% height=100% cellspacing=0 bgcolor=#000000>\n");
				$my_color = $class_colors[$toon_class];
				print("\t<tr><th colspan=2><font color='$my_color'>$toon_class</font></th></tr>\n");
			}

			$rank_color = $rank_colors[$toon_rank_id];
			print("\t<tr bgcolor='$rank_color'>\n");
			print("\t\t<td><input type=checkbox name=raid_att[$i] value=$toon_dbid> <a href='toon.php?id=$toon_dbid'><font color='$my_color'>$toon_name</font></a></td>\n");
			print("\t\t<td><font color=#ffffff>$toon_ct</font></td>\n");
			print("\t</tr>\n");

			$i++;
		}

		print("</table></td></tr></table>\n");
	} else {
		print("\t<tr><td align=center><font size=-1 color=red>The clock for this raid has been stopped.  It is now closed.</font></td></tr>\n");
	}

	pg_free_result($result);
}

print("<tr bgcolor=#aaaaaa><td>&nbsp;</td></tr>\n");
print("</table></form>\n");

pg_close($dbconn);

?>
</body>
</html>
