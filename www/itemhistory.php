<?

// $Id: itemhistory.php,v 1.4 2006/12/04 17:39:43 mdg Exp $

require_once("common.php");
?>

<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP - Items</title>
</head>
<body>

<?
include('header.php');

?>
<table align=center width=100% valign=top border=0 cellspacing=0>
<tr valign=top><td>

<? include("itemlist.inc"); ?>

</td><td>

<?

// Drop History Table

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=6><font color=#FFFFFF>Drop History</font></td></tr>\n";

if ($LD_MODE == 1) {
	echo "<tr bgcolor=#aaaaaa align=center><td colspan=6><font size=-1 color=red>* Red items indicate DKP values that are inconsistent with the <b>current</b> default DKP value for that item</font></td></tr>\n";
}

echo "<tr bgcolor=#aaaaaa><th>[Date]</th><th>[Dungeon]</th><th>[Raider]</th><th>[Item]</th>";

if ($LD_MODE == 1) {
	echo "<th>[Default Value]</th><th>[Cost]</th>";
}

echo "</tr>\n";

$query = "select raid_id, dungeon, raid_date, toon_id, toon_name, item_id, item_name, default_value, value from view_loot order by raid_date desc, item_name, toon_name";

$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$item_raid_id = array_shift($line);
	$item_dungeon = array_shift($line);
	$item_raid_date = array_shift($line);
	$item_toon_id = array_shift($line);
	$item_toon = array_shift($line);
	$item_id = array_shift($line);
	$item_name = array_shift($line);
	$item_default_value = array_shift($line);
	$item_value = array_shift($line);

	if (++$i % 2) {
		echo "\t<tr align=center>\n";
	} else {
		echo "\t<tr  align=center bgcolor=#dddddd>\n";
	}
?>
<td><a href="raid.php?id=<? print("$item_raid_id"); ?>"><? print("$item_raid_date"); ?></a></td>
<td><? print("$item_dungeon"); ?></td>
<?

if ($item_toon_id > 0) {
	print("<td><a href='toon.php?id=$item_toon_id'>$item_toon</a></td>\n");
} else {
	print("<td>$item_toon</td>\n");
}

?>
<td><a href="item.php?id=<? print("$item_id"); ?>"><? print("$item_name"); ?></a></td>
<?
	if ($LD_MODE == 1) {
		echo "<td align=right>$item_default_value</td>\n<td align=right>";

		if ($item_default_value != $item_value) {
			print("<font color=red>$item_value</font>");
		} else {
			print("$item_value");
		}

		echo "</td>";
	}

	echo "</tr>\n";
}
print("\t<tr bgcolor=#aaaaaa><th colspan=6>&nbsp;</th></tr>\n");
print("</table>\n");

pg_free_result($result);

pg_close($dbconn);

?>
</td></tr></table>

</body>
</html>

