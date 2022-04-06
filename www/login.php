<?

// $Id: login.php,v 1.3 2006/12/04 17:39:44 mdg Exp $

require_once("common.php");

if ($HTTP_AUTH) {
	header('WWW-Authenticate: Basic realm="DKP"');
	header('HTTP/1.0 401 Unauthorized');
	echo "Authorization Required";
} else {
?>
<html> <head> 	<link rel="stylesheet" href="style.css" type="text/css" /><title>DKP</title> </head> <body bgcolor=#d0d0d0>
<table width=100% height=100% align=center><tr><td align=center valign=center>
        <font color=red>Authorized Users Only</font><br>
        <form method=post action=index.php>
        <b>Username:</b> <input type=textbox name=auth_user><br>
        <b>Password:</b> <input type=password name=auth_pass><br>
        <input type=submit name=form_auth value="Log In"> <input type=reset>
        </form>
</td></tr></table>
</body></html>
<?
}

exit();
