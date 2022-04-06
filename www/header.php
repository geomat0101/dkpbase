<?

// $Id: header.php,v 1.8 2006/07/19 18:30:40 mdg Exp $

?>
<center>
<?
print("<font size=-3><a href=\"index.php\">[Main]</a> | <a href=\"itemhistory.php\">[Items]</a> | <a href=\"bank.php\">[Bank]</a> | <a href=\"graphs\">[Charts and Graphs]</a> | <a href=\"waitlist.php\">[The List]</a>");

if (isset($_SESSION['auth']) && ($_SESSION['auth'] >= $AUTH_ADMIN_REQ)) {
	print(" | <a href=\"admin.php\">[Admin]</a> | <a href=\"password.php\">[Change Password]</a>");
}

print("</font>\n");

if (isset($_SESSION['uid'])) {

?>
<br>Logged in as <? print($_SESSION['name']); ?>
<form method=post><input type=submit name=logout value="Log Out">
<br><font size=-3><a href="/bugzilla/enter_bug.cgi" target=_BLANK>[Bugs and Feature Requests]</a></font>
</form>
<?

} else {

?>
<br>Not Logged In: <font size=-3><a href="login.php">[Log In]</a></font>
<br><font size=-3><a href="/bugzilla/enter_bug.cgi" target=_BLANK>[Bugs and Feature Requests]</a></font>
<?

}
?>
</center>
<hr width=30%>

