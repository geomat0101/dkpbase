<?

// $Id: password.php,v 1.3 2006/12/04 17:39:44 mdg Exp $

require_once("common.php");

if (!isset($_SESSION['uid'])) {
	header("Location:index.php");
	exit();
}

$UID = $_SESSION['uid'];
?>

<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP - Change Password</title>
</head>
<body>

<?
include('header.php');

// Process Form Requests

if (isset($_POST['pass_change'])) {
	$pass_current = $_POST['pass_current'];
	$pass_new1 = $_POST['pass_new1'];
	$pass_new2 = $_POST['pass_new2'];

	if ($pass_new1 != $pass_new2) {
		print("<h1><center><font color=red>ERROR: New passwords don't match</font></center></h1>\n");
	} else {
		$query = "SELECT password from users where id = '$UID'";
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());
		$line = pg_fetch_array($result, null, PGSQL_ASSOC);
		$pass_db = array_shift($line);
		pg_free_result($result);

		if ($pass_db != $pass_current) {
			print("<h1><center><font color=red>ERROR: Incorrect Current Password</font></center></h1>\n");
		} else {
			$query = "UPDATE users set password = '$pass_new1' where id = '$UID'";
			$result = pg_query($query) or die('Query failed: ' . pg_last_error());
			pg_free_result($result);

			print("<h1><center><font color=green>SUCCESS: Password Changed</font></center></h1>\n");
		}
	}
}


// Password Form

echo "<table border=0 cellspacing=0 align=center width=70%>\n";
echo "<tr bgcolor=#000000><td colspan=2><font color=#FFFFFF>Change Password</font></td></tr>\n";
?>
<form method=POST>
<tr bgcolor=#aaaaaa><td align=right><b>Current Password</b></td><td align=left><input type=password name=pass_current></td></tr>
<tr bgcolor=#aaaaaa><td align=right><b>New Password</b></td><td align=left><input type=password name=pass_new1></td></tr>
<tr bgcolor=#aaaaaa><td align=right><b>Confirm New Password</b></td><td align=left><input type=password name=pass_new2></td></tr>
<tr bgcolor=#aaaaaa><td align=center colspan=2><input type=submit name=pass_change value="Change Password"> <input type=reset></td></tr>
</form>
</table>
<?

pg_close($dbconn);

?>
</body>
</html>
