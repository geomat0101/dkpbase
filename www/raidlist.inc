<?

// $Id: raidlist.inc,v 1.3 2006/03/27 16:55:51 mdg Exp $

// Raid Management

if (isset($_POST['raid_add']) && isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ)) {
        $raid_dungeon = $_POST['raid_dungeon'];
        $raid_date = $_POST['raid_date'];

        $query = "INSERT INTO raids (dungeon_id, raid_date, value) values ('$raid_dungeon', '$raid_date', (select value from dungeons where id = '$raid_dungeon'))";
        $result = pg_query($query) or die('Query failed: ' . pg_last_error());
        pg_free_result($result);
}

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=4><font color=#FFFFFF>Raids</font></td></tr>\n";

if (isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ)) {
	echo "<form method=post><tr bgcolor=#aaaaaa><td align=center colspan=4><select name=raid_dungeon><option value=0 SELECTED>Choose Dungeon</option>\n";
	$query = 'SELECT id, name from dungeons order by name';
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());

	$i = 0;
	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$d_id = array_shift($line);
		$d_name = array_shift($line);

		print("\t<option value=$d_id>$d_name</option>\n");
	}

	$today = date("Y-m-d");
	echo "</select> <input type=textbox name=raid_date value=$today><br><input type=submit name=raid_add value=\"Add Raid\"> <input type=reset></td></tr></form>\n";
}

echo "<tr bgcolor=#aaaaaa><th>Date</th><th>Dungeon</th><th>DKP</th><th>Length</th></tr>\n";

$query = 'SELECT id, dungeon, raid_date, value, raid_length from view_raids order by raid_date desc';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$raid_id = array_shift($line);
	$raid_dungeon = array_shift($line);
	$raid_date = array_shift($line);
	$raid_value = array_shift($line);
	$raid_length = array_shift($line);

        if (++$i % 2) {
                echo "\t<tr align=center>\n";
        } else {
                echo "\t<tr align=center bgcolor=#dddddd>\n";
        }

        echo "\t\t<td><a href=\"raid.php?id=$raid_id\">$raid_date</a></td>\n";
        echo "\t\t<td>$raid_dungeon</td>\n";
        echo "\t\t<td>$raid_value</td>\n";
        echo "\t\t<td>$raid_length</td>\n";
        echo "\t</tr>\n";

}

?>
<tr bgcolor=#aaaaaa><td colspan=4>&nbsp;</td></tr>
</table>
