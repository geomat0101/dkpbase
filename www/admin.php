<?

// $Id: admin.php,v 1.3 2006/12/04 17:39:43 mdg Exp $

require_once("common.php");

if (! isset($_SESSION['auth']) || ($_SESSION['auth'] < $AUTH_ADMIN_REQ)) {
	header("Location:index.php");
	exit();
}
?>

<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP Admin</title>
</head>
<body>

<?
include('header.php');

// Process Form Requests

if ($_SESSION['auth'] >= $AUTH_USER_ADMIN_REQ) {
	if (isset($_POST['user_add'])) {
		$username = $_POST['username'];
		$email = $_POST['email'];
		$password = $_POST['password'];

		$query = "INSERT INTO users (name, email, password) values ('$username', '$email', '$password')";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		pg_free_result($result);
	}
}

if (isset($_POST['toon_add'])) {
	$toon_name = $_POST['toon_name'];
	$toon_class = $_POST['toon_class'];

	$query = "INSERT INTO toons (name, class_id) values ('$toon_name', '$toon_class')";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);
}

if (isset($_POST['dungeon_add'])) {
	$d_type = $_POST['d_type'];
	$d_name = $_POST['d_name'];
	$d_value = $_POST['d_value'];

	$query = "INSERT INTO dungeons (name, loot_type, value) values ('$d_name', '$d_type', '$d_value')";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);
}

?>
<table width=100% align=center border=0 cellspacing=0>
<tr><td colspan=3>
<?

// User Management Table

$query = 'SELECT name, email FROM users order by name';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=2><font color=#FFFFFF>Admin Users</font></td></tr>\n";
echo "<tr bgcolor=#aaaaaa><th>Username</th><th>Email Address</th></tr>\n";

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	if (++$i % 2) {
		echo "\t<tr align=center>\n";
	} else {
		echo "\t<tr align=center bgcolor=#dddddd>\n";
	}

	foreach ($line as $col_value) {
		echo "\t\t<td>$col_value</td>\n";
	}

	echo "\t</tr>\n";
}

pg_free_result($result);


if ($_SESSION['auth'] >= $AUTH_USER_ADMIN_REQ) {
?>
<form method=POST>
<tr bgcolor=#aaaaaa><td align=center colspan=2><input type=textbox name=username value="User Name"> <input type=textbox name=email value="E-mail Address"> <input type="textbox" name=password value="Password"></td></tr>
<tr bgcolor=#aaaaaa><td align=center colspan=2><input type=submit name=user_add value="Add New User"> <input type=reset></td></tr>
</form>
</table>
<?
} else {
?>
<tr bgcolor=#aaaaaa><td colspan=2>&nbsp;</td></tr>
</table>
<?
} // END AUTH_USER_ADMIN_REQ RESTRICTION

?>
</td></tr>
<tr valign=top><td>
<?

// Toon Management Table

$query = 'SELECT id, name FROM toon_classes order by name';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=2><font color=#FFFFFF>Toons</font></td></tr>\n";
echo "<form method=post><tr bgcolor=#aaaaaa><td align=center colspan=2><input type=textbox name=toon_name value=\"Toon Name\"><br><select name=toon_class>\n";
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$class_id = array_shift($line);
	$class_name = array_shift($line);

	echo "\t<option value=$class_id>$class_name</option>\n";
}
echo "</select> <br> <input type=submit name=toon_add value=\"Add Toon\"> <input type=reset></td></tr></form>\n";
echo "<tr bgcolor=#aaaaaa><th>Name</th><th>Class</th></tr>\n";

pg_free_result($result);

$query = 'SELECT id, name, class FROM view_toons order by name';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

$i = 0;
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	if (++$i % 2) {
		echo "\t<tr align=center>\n";
	} else {
		echo "\t<tr align=center bgcolor=#dddddd>\n";
	}
	$toon_id = array_shift($line);
	$toon_name = array_shift($line);
	$toon_class = array_shift($line);

	echo "\t\t<td><a href=\"toon.php?id=$toon_id\">$toon_name</a></td><td>$toon_class</td>\n";
	echo "\t</tr>\n";
}

pg_free_result($result);

?>
<tr bgcolor=#aaaaaa><td colspan=2>&nbsp;</td></tr>
</table>

</td><td>
<? include("raidlist.inc"); ?>

</td><td>
<?


// Dungeon Management Table

echo "<table border=0 cellspacing=0 align=center width=100%>\n";
echo "<tr bgcolor=#000000><td colspan=3><font color=#FFFFFF>Dungeons</font></td></tr>\n";
?>
<form method=POST>
<tr bgcolor=#aaaaaa><td align=center colspan=3><input type=textbox name=d_name value="Dungeon Name"> <select name=d_type> <option value=0 SELECTED>DKP Type</option>
<?

$query = 'SELECT id, name from dungeon_loot_types order by name';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$dt_id = array_shift($line);
	$dt_name = array_shift($line);

	echo "\t<option value=$dt_id>$dt_name</option>\n";
}

pg_free_result($result);
echo "</select><br><input type=textbox name=d_value value=\"Value\"> <br> <input type=submit name=dungeon_add value=\"Add Dungeon\"> <input type=reset></td></tr>\n";

echo "<tr bgcolor=#aaaaaa><th>Name</th><th>DKP Type</th><th>Default Value</th></tr>\n";

$query = 'SELECT id, name, type, value from view_dungeons order by name';
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
	$d_type = array_shift($line);
	$d_value = array_shift($line);

	echo "\t\t<td><a href=\"dungeon.php?id=$d_id\">$d_name</a></td><td>$d_type</td><td>$d_value</td>\n";
	echo "\t</tr>\n";
}

pg_free_result($result);
echo "\t<tr bgcolor=#aaaaaa><td colspan=3>&nbsp;</td></tr></table>\n";
echo "<hr width=30%>\n";

include("itemlist.inc");
?>
</td></tr></table>
<?

pg_close($dbconn);

?>
</body>
</html>
