<?

// $Id: item.php,v 1.5 2006/12/04 17:39:43 mdg Exp $

require_once("common.php");

if (! isset($_REQUEST['id'])) {
	header("Location:index.php");
	exit();
}

$item_id = $_REQUEST['id'];

?>

<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP - Item</title>
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
	if (isset($_POST['item_mod'])) {
		$item_name = $_POST['item_name'];
		$item_default_value = $_POST['item_default_value'];
		$item_dungeon_id = $_POST['item_dungeon_id'];

		if ($item_dungeon_id == 0) {
			$query = "UPDATE items set name = '$item_name', value = '$item_default_value', dungeon_id = NULL where id = '$item_id'";
		} else {
			$query = "UPDATE items set name = '$item_name', value = '$item_default_value', dungeon_id = '$item_dungeon_id' where id = '$item_id'";
		}
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
		print("<center><h1>Item Updated</h1></center>\n");
	}
}


// Item Detail Table

$query = "select id, name from dungeons";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$dungeons = array();
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$dungeon_id = array_shift($line);
	$dungeon_name = array_shift($line);

	$dungeons[$dungeon_id] = $dungeon_name;
}

asort($dungeons);
pg_free_result($result);

$query = "select name, value, dungeon_id, dungeon_name from view_items where id = '$item_id'";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

echo "<form method=POST>\n";
echo "<table border=0 cellspacing=0 align=center>\n";
echo "<tr bgcolor=#000000><td colspan=2><font color=#FFFFFF>Item Detail</font></td></tr>\n";
echo "<tr bgcolor=#aaaaaa><td colspan=2>&nbsp;</td></tr>\n";

$line = pg_fetch_array($result, null, PGSQL_ASSOC);
$item_name = array_shift($line);
$item_default_value = array_shift($line);
$item_dungeon_id = array_shift($line);
$item_dungeon_name = array_shift($line);
pg_free_result($result);

?>
<tr><th align=right>Name: </th><td align=left><input type=textbox name=item_name value="<? print($item_name); ?>"></td></tr>
<tr bgcolor=#dddddd><th align=right>Default Value: </th><td align=left><input type=textbox name=item_default_value value="<? print($item_default_value); ?>"></td></tr>
<tr><th align=right>Drops In: </th><td align=left><select name=item_dungeon_id><option value=0>*** World Drop ***</option>
<?
foreach ($dungeons as $dungeon_id => $dungeon_name) {
	print("\t<option value=$dungeon_id");
	if ($item_dungeon_id == $dungeon_id) {
		print(" SELECTED");
	}
	print(">$dungeon_name</option>\n");
}
print("</select>\n");

if ($admin_auth) {
?>
<tr bgcolor=#aaaaaa><td align=center colspan=2><input type=submit name=item_mod value="Modify Item Detail"> <input type=reset></td></tr>
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

// Drop History Table

echo "<form method=POST><table border=0 cellspacing=0 align=center width=70%>\n";
echo "<tr bgcolor=#000000><td colspan=5><font color=#FFFFFF>Drop History</font></td></tr>\n";
print("<tr bgcolor=#aaaaaa><th>[Date]</th><th>[Dungeon]</th><th>[Raider]</th>");

if ($LD_MODE == 1) {
	print("<th>[Purchase Price]</th>");
}

print("</tr>\n");

$query = "SELECT r.dungeon, r.raid_date, l.raid_id, l.toon_name, l.toon_id, l.value from view_loot l, view_raids r where l.item_id = '$item_id' and l.raid_id = r.id order by raid_date desc, toon_name";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
$red_items = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$item_dungeon = array_shift($line);
	$item_date = array_shift($line);
	$item_raidid = array_shift($line);
	$item_toon = array_shift($line);
	$item_toonid = array_shift($line);
	$item_value = array_shift($line);

	if (++$i % 2) {
		print("\t<tr align=center>\n");
	} else {
		print("\t<tr align=center bgcolor=#dddddd>\n");
	}

	print("\t\t<td><a href=\"raid.php?id=$item_raidid\">$item_date</a></td>\n");
	print("\t\t<td>$item_dungeon</td>\n");
	if ($item_toonid > 0) {
		print("\t\t<td><a href=\"toon.php?id=$item_toonid\">$item_toon</a></td>\n");
	} else {
		print("\t\t<td>$item_toon</td>\n");
	}

	if ($LD_MODE == 1) {
		if ($item_value != $item_default_value) {
			print("\t\t<td><font color=red>$item_value</font></td>\n");
			$red_items = 1;
		} else {
			print("\t\t<td>$item_value</td>\n");
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


</body>
</html>
