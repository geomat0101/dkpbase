<?

// $Id: bank.php,v 1.2 2006/12/04 17:39:43 mdg Exp $

require_once("common.php");

$admin_auth = 0;
if (isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ)) {
	$admin_auth = 1;
}

?>

<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP - Bank</title>
</head>
<body>

<?
include('header.php');


// Process Form Requests

if ($admin_auth) {
	if (isset($_POST['mod_item_qty'])) {
		$item_id = $_POST['item_id'];
		$item_qty = $_POST['item_qty'];

		$query = "UPDATE items set bank_inventory = '$item_qty' where id = '$item_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);

		print("<center><h1>Quantity Updated</h1></center>\n");
	}

	if (isset($_POST['item_xchg'])) {
		$item_xchg_from = $_POST['item_xchg_from'];
		$item_xchg_to   = $_POST['item_xchg_to'];
		$item_xchg_qty  = $_POST['item_xchg_qty'];

		$query = "UPDATE items set bank_inventory = (bank_inventory - 1) where id = '$item_xchg_from'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);

		$query = "UPDATE items set bank_inventory = (bank_inventory + '$item_xchg_qty') where id = '$item_xchg_to'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);

		print("<center><h1>Item Exchanged</h1></center>\n");
	}

	if (isset($_POST['item_add'])) {
		$item_id = $_POST['item_id'];
		$item_qty = $_POST['item_qty'];

		$query = "UPDATE items set bank_inventory = (bank_inventory + '$item_qty') where id = '$item_id'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);

		print("<center><h1>Item Added to Bank</h1></center>\n");
	}
}


// Get Item Info

if ($admin_auth) {
	$items_all = array();
	$items_in_bank = array();
	$items_not_in_bank = array();

	$query = "select id, name, bank_inventory from items order by bank_inventory, name";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$item_id = array_shift($line);
		$item_name = array_shift($line);
		$item_qty = array_shift($line);

		$items_all[$item_id] = $item_name;

		if ($item_qty > 0) {
			$items_in_bank[$item_id] = $item_name;
		} else {
			$items_not_in_bank[$item_id] = $item_name;
		}
	}

	asort($items_all);
	asort($items_in_bank);
	asort($items_not_in_bank);
}


// Item Exchange

if ($admin_auth) {
	echo "<table border=0 cellspacing=0 align=center>\n";
	echo "<tr bgcolor=#000000><td colspan=3><font color=#FFFFFF>Single Item Exchange</font></td></tr>\n";
	echo "<tr align=center bgcolor=#aaaaaa><td><form method=POST><select name=item_xchg_from><option value=0>Change From</option>\n";
	foreach ($items_in_bank as $item_id => $item_name) {
		print("\t<option value=$item_id>$item_name</option>\n");
	}
	echo "</select> =&gt; <select name=item_xchg_to><option value=0>Change To</option>\n";
	foreach ($items_all as $item_id => $item_name) {
		print("\t<option value=$item_id>$item_name</option>\n");
	}
	echo "</select> Qty: <input textbox size=5 name=item_xchg_qty value=1> <input type=submit name=item_xchg value=Convert></form></td></tr>\n";
	echo "</table>\n";

?>
<hr width=30%>
<?
}


// Bank Inventory Table

echo "<table border=0 cellspacing=0 align=center>\n";
echo "<tr bgcolor=#000000><td colspan=3><font color=#FFFFFF>Bank Inventory</font></td></tr>\n";

if ($admin_auth) {
	print("<tr bgcolor=#aaaaaa><td colspan=2><form method=POST><select name=item_id><option value=0>Choose New Item</option>\n");

	foreach ($items_not_in_bank as $item_id => $item_name) {
		print("\t<option value=$item_id>$item_name</option>\n");
	}

	print("</select></td><td>Qty: <input type=textbox size=5 name=item_qty value=1> <input type=submit name=item_add value='Add Item'></form></td></tr>\n");
}

echo "<tr bgcolor=#aaaaaa><th>[Item]</th>";

if ($LD_MODE == 1) {
	echo "<th>[Default Value]</th>";
}

echo "<th>[Qty]</th></tr>\n";

$query = "select id, name, value, bank_inventory from items where bank_inventory > 0 order by name";

$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$item_id = array_shift($line);
	$item_name = array_shift($line);
	$item_default_value = array_shift($line);
	$item_bank_qty = array_shift($line);

	if (++$i % 2) {
		echo "\t<tr align=center>\n";
	} else {
		echo "\t<tr align=center bgcolor=#dddddd>\n";
	}

?>
<td><a href="item.php?id=<? print("$item_id"); ?>"><? print("$item_name"); ?></a></td>
<?
	if ($LD_MODE == 1) {
		echo "<td>$item_default_value</td>\n";
	}

	if ($admin_auth) {
		echo "<td><form method=POST><input type=hidden name=item_id value=$item_id><input type=textbox size=5 name=item_qty value=$item_bank_qty> <input type=submit name=mod_item_qty value=Update></form></td></tr>\n";
	} else {
		echo "<td>$item_bank_qty</td></tr>\n";
	}
}
print("\t<tr bgcolor=#aaaaaa><th colspan=3>&nbsp;</th></tr>\n");
print("</table>\n");

pg_free_result($result);

pg_close($dbconn);

?>

</body>
</html>

