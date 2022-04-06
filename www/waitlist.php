<?

// $Id: waitlist.php,v 1.5 2006/12/04 17:39:44 mdg Exp $

require_once("common.php");

function randomkeys($length) {
	$pattern = "123456789abcdefghijklmnpqrstuvwxyz";
	for($i=0;$i<$length;$i++) {
		$key .= $pattern{rand(0,33)};
	}
	return $key;
}

?>
<html>
<head>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>DKP</title>
	<META http-equiv=Cache-Control content=no-cache>
	<META http-equiv=Pragma content=no-cache>
	<META name="Expires" content="Fri, 01 Jan 1990 00:00:00 GMT">
</head>
<body bgcolor=#d0d0d0>
<?

include("header.php");

if (isset($_POST['list_app'])) {
	$toon_id = $_POST['list_toon'];
	$list_raid = $_POST['list_raid'];

	if ($list_raid <= 0) {
		print("<center><font color=red><h1>You Must Select a Raid</h1></font></center>\n");
		exit();
	}

	$new_challenge = randomkeys(5);
	$query = "UPDATE toons set last_challenge = '$new_challenge' where id = '$toon_id'";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
}

if (isset($_POST['list_vrfy'])) {
	$toon_id = $_POST['list_toon'];
	$toon_pass_attempt = $_POST['list_pass'];
	$list_raid = $_POST['list_raid'];
	$list_challenge = $_POST['list_challenge'];

	$query = "select ('$list_challenge' ilike last_challenge) from toons where id = '$toon_id'";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());

	$line = pg_fetch_array($result, null, PGSQL_ASSOC);
	$verified = array_shift($line);

	pg_free_result($result);

	if ($verified == 'f') {
		print("<center><font color=red><h1>Verification Failed</h1></font>\n");
		print("\t<form method=POST>\n");
		print("\t\t<input type=hidden name=list_toon value='$toon_id'>\n");
		print("\t\t<input type=hidden name=list_raid value='$list_raid'>\n");
		print("\t\t<input type=submit name=list_app value='Register Again'>\n");
		print("\t</form></center>\n");
		exit();
	}

	$new_challenge = randomkeys(5);
	$query = "UPDATE toons set last_challenge = '$new_challenge' where id = '$toon_id'";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	$query = "select id from waitlist_requests where toon_id = '$toon_id' and raid_id = '$list_raid' and last_expire >= now()";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());

	if (pg_numrows($result) > 0) {
		$line = pg_fetch_array($result, null, PGSQL_ASSOC);
		$req_id = array_shift($line);

		pg_free_result($result);

		$query = "UPDATE waitlist_requests set last_expire = (now() + '2:00:00'::interval) where id = '$req_id'";
	} else {
		$query = "INSERT into waitlist_requests (toon_id, raid_id, last_expire) values ('$toon_id', '$list_raid', (now() + '2:00:00'::interval))";
	}

	$result = pg_query($query) or die('Query failed: ' . pg_last_error());
	pg_free_result($result);

	print("<center><font color=green><h1>Registration / Renewal Complete: It will expire in 2 hours</h1></font>\n");
	print("\t<form method=POST>\n");
	print("\t\t<input type=hidden name=list_toon value='$toon_id'>\n");
	print("\t\t<input type=hidden name=list_raid value='$list_raid'>\n");
	print("\t\t<input type=submit name=list_app value='Renew Registration'>\n");
	print("\t</form><br><a href='raid.php?id=$list_raid'>View Raid Detail</a></center>\n");

	echo "<center><h1>Waiting List</h1></center>\n";

	$query = "SELECT toon_id, toon, class, first_request, last_expire, (last_expire < now()) as expired, clock_time, approved FROM view_waitlist where raid_id = '$list_raid' order by expired, first_request";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());

	echo "\t<table align=center border=1 bgcolor=#ffffff>\n";
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
		print("\t\t<td>$toon_req_approved</td>\n");
		print("\t</tr>\n");
	}

	print("</table>\n");

	pg_free_result($result);
	exit();
}

?>
<table width=100% height=50% align=center><tr><td align=center valign=center>
        <h2>The List</h2><br>
        <form method=post>
<?
if (! isset($_POST['list_app']) && ! isset($_POST['list_vrfy'])) {
?>
        <select name=list_toon><option value=0>Who are You?</option>
<?
	$query = "select id, name from toons where id > 0 order by name";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());

	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$toon_id = array_shift($line);
		$toon_name = array_shift($line);

		print("\t\t<option value=$toon_id>$toon_name</option>\n");
	}

	pg_free_result($result);
?>
	</select>
	<select name=list_raid><option value=0>Choose Raid</option>
<?
	$query = "select id, raid_date || ' - ' || dungeon as description from view_raids where raid_date >= now() - '1 day'::interval and raid_date <= now() and raid_stop is null order by raid_date desc, dungeon";
	$result = pg_query($query) or die('Query failed: ' . pg_last_error());

	while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
		$raid_id = array_shift($line);
		$raid_desc = array_shift($line);

		print("\t\t<option value=$raid_id>$raid_desc</option>\n");
	}

	pg_free_result($result);
?>
	</select><br>
        <input type=submit name=list_app value="Register"> <input type=reset>
<?
} else if (isset($_POST['list_app'])) {
	print("\t<h3>You can refresh if the picture is completely indecipherable</h3>\n");
	print("\t<img src='antispam.php?id=$toon_id'> Enter Text in Picture: <input type=textbox name=list_challenge><input type=hidden name=list_raid value='$list_raid'><input type=hidden name=list_toon value='$toon_id'><br>\n");
        print("\t<input type=submit name=list_vrfy value='Register'> <input type=reset>\n");
}
?>
        </form>
</td></tr></table>
</body></html>
