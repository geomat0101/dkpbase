<?

// $Id: itemlist.inc,v 1.4 2006/06/27 20:47:42 mdg Exp $

require_once("common.php");

if (isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ) && isset($_POST['item_add'])) {
	$item_name = $_POST['item_name'];
	$item_value = $_POST['item_value'];
	$item_dungeon_id = $_POST['item_dungeon_id'];

	if ($item_dungeon_id == 0) {
		$query = "INSERT INTO items (name, value, dungeon_id) values ('$item_name', '$item_value', NULL)";
	} else {
		$query = "INSERT INTO items (name, value, dungeon_id) values ('$item_name', '$item_value', '$item_dungeon_id')";
	}

	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);
}


// Item Management Table

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

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=4><font color=#FFFFFF>Items</font></td></tr>\n";
if (isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ)) {
?>
<form method=POST>
<tr bgcolor=#aaaaaa><td align=center colspan=4><input type=textbox name=item_name value="Item Name"><br>
<input type=textbox name=item_value value="Value"><br>
<select name=item_dungeon_id><option value=0>*** World Drop ***</option>
<?
foreach ($dungeons as $dungeon_id => $dungeon_name) {
	print("\t<option value=$dungeon_id>$dungeon_name</option>\n");
}
?>
</select><br>
<input type=submit name=item_add value="Add Item"> <input type=reset></td></tr>
</form>
<?
}

echo "<tr bgcolor=#aaaaaa><th>Name</th>";

if ($LD_MODE == 1) {
	echo "<th>Default Value</th>";
}

echo "<th>Banked</th><th>Drops In</th></tr>\n";

$query = 'SELECT id, name, value, bank_inventory, dungeon_name from view_items order by name';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	if (++$i % 2) {
		echo "\t<tr align=center>\n";
	} else {
		echo "\t<tr align=center bgcolor=#dddddd>\n";
	}

	$d_id = array_shift($line);
	$d_name = array_shift($line);
	$d_value = array_shift($line);
	$d_bank_inv = array_shift($line);
	$d_dungeon_name = array_shift($line);

	echo "\t\t<td><a href=\"item.php?id=$d_id\">$d_name</a></td>";

	if ($LD_MODE == 1) {
		echo "<td>$d_value</td>";
	}

	echo "<td>$d_bank_inv</td>\n";
	echo "<td>$d_dungeon_name</td>\n";
	echo "\t</tr>\n";
}

pg_free_result($result);
echo "\t<tr bgcolor=#aaaaaa><td colspan=4>&nbsp;</td></tr></table>\n";

