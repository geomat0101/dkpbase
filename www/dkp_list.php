<?php

// $Id: dkp_list.php,v 1.2 2006/03/27 15:55:53 mdg Exp $

/******************************
 * GetDKP Plus
 *
 * © Corgan @ Server Antonidas PvE German -> www.seniorenraid.de
 * ------------------
 * dkp_list.php
 *
 * Version 1.9
 * Support German -> http://eqdkp-ger-mod.pytalhost.de/forum/viewforum.php?f=3
 * Support English -> http://ui.worldofwar.net/ui.php?id=1567
 ******************************/

/******
 * Revised for compatibility with 40MD DKPBase
 * Garkar @ Cenarius
 ******/

#$table_prefix = "eqdkp13_"; // prefix to your eqdkp tables, "eqdkp_" is default.

// XXX: Don't use this setting with 40MD -- mdg
#$table_prefixNS = "eqdkpNonSet_";  // set only if u have 2 eqdkp !!!!!  LEAVE BLANK IF U DONT HAVE 2 EQDKP SYSTEMS  !!!!!!!!





############# you dont have to change anything below !!!!  ######################################

require_once("common.php");

$version = "1.9";
$total_players = 0;
$total_items = 0;
$total_points = 0;
$eqdkp_version = "1.3.x";
$date_created = date("D M j G:i:s T Y");

define('EQDKP_INC', true);
$eqdkp_root_path = './';
include_once($eqdkp_root_path . 'common.php');

function strto_wowutf($str)
{
	$str_encoded = utf8_encode($str);
	return $str_encoded;
}

############# ######################################

// Get raidpoints without spitting out the whole page

/***
 * Total Available DKP: $total_points, $total_pointsset
 * Total Number of Drops: $total_items, $setitems
 * Total Number of Raiders: $total_players
 ***/


$query = 'SELECT sum(available_dkp) as total_points, count(name) as total_players from view_agg_summary';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
$line = pg_fetch_array($result, null, PGSQL_ASSOC);
$total_points = array_shift($line);
$total_players = array_shift($line);
pg_free_result($result);

$query = 'SELECT count(*) from view_loot';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
$line = pg_fetch_array($result, null, PGSQL_ASSOC);
$total_items = array_shift($line);
pg_free_result($result);

// XXX: unsupported - mdg
				if ($table_prefixNS <> "")
				{

					$member_results = mysql_query("SELECT * FROM ".$table_prefixNS."members") or die(mysql_error());
					while($row = mysql_fetch_array($member_results, MYSQL_ASSOC)) {
						$player_dkps = ($row['member_earned'] - $row['member_spent']) + $row['member_adjustment'];
						$total_pointsns+=$player_dkps;
					}

					$total_points = $total_pointsset + $total_pointsns ;

					// Get total items
					$item_results = mysql_query("SELECT * FROM ".$table_prefixNS."items") or die(mysql_error());
					$Nonsetitems = mysql_num_rows($item_results);
					$total_items = $setitems  + $Nonsetitems;

				}
// END XXX


				echo "DKPInfo = {\n";
								echo "     [\"date\"] = \"$date_created\",\n";
								echo "     [\"process_dkp_ver\"] = \"$version\",\n";
								echo "     [\"total_players\"] = $total_players,\n";
								echo "     [\"total_items\"] = $total_items,\n";
								echo "     [\"total_points\"] = $total_points,\n";
// XXX: unsupported - mdg
	if ($table_prefixNS <> ""){
								echo "     [\"set_items\"] = $setitems,\n";
								echo "     [\"nonset_items\"] = $Nonsetitems,\n";
								echo "     [\"total_points_set\"] = $total_pointsset,\n";
								echo "     [\"total_points_ns\"] = $total_pointsns,\n";

						      }
// END XXX
				echo "}";

#############################################
# DKP (set)
############################################


#$sql = "SELECT
#		ra.member_name,
#        c.class_name as member_class,
#		m.member_earned + m.member_adjustment - m.member_spent as current_dkp
#	FROM
#		".$table_prefix."raids r, ".$table_prefix."raid_attendees ra, ".$table_prefix."members m, ".$table_prefix."classes c
#	WHERE
#		ra.raid_id = r.raid_id
#		AND m.member_name = ra.member_name
#		AND m.member_class_id = c.class_id
#	GROUP BY
#		ra.member_name
#	ORDER BY
#member_name ASC";

define(TAB, "\t");
define(CRLF, "\r\n");

$output = 'gdkp = {'."\r\n";
$output .=  TAB.'["players"] = {'.CRLF;
$format =
	TAB.TAB.'["%s"] = {'.CRLF.
	TAB.TAB.TAB.'["dkp"] = %s,'.CRLF.
	TAB.TAB.TAB.'["class"] = "%s",'.CRLF.
	TAB.TAB.'},'.CRLF;

// $sql = "SELECT m.member_name, c.class_name as member_class, m.member_earned + m.member_adjustment - m.member_spent as current_dkp FROM ".$table_prefix."members m, ".$table_prefix."classes c WHERE m.member_class_id = c.class_id GROUP BY m.member_name ORDER BY member_name ASC";

/***
 * member_name
 * member_class
 * current_dkp: available dkp
 * ORDER name ascending
 ***/

$query = 'SELECT name, class, available_dkp from view_agg_summary ORDER BY name';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$member_name = array_shift($line);
	$member_class = array_shift($line);
	$current_dkp = array_shift($line);

	$output .= sprintf($format,
			strto_wowutf($member_name),
			$current_dkp,
			strto_wowutf($member_class)
		);
}

pg_free_result($result);

$output = substr($output, 0, strlen($output)-3);
echo $output.CRLF.TAB.'}'.CRLF.'}'.CRLF;


	//----------------------------------------------------------
	// DKP_ROLL_PLAYERS Output
	//----------------------------------------------------------

/***
 * toon_name: $buyer
 * item_name
 * item_value
 ***/

$query = 'SELECT toon_name, item_name, value from view_loot';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
	$buyer = strtolower(array_shift($line));
	$item = array_shift($line);
	$item_value = array_shift($line);

	$player_data[$buyer]['Items'][$item] = $item_value;
}

pg_free_result($result);

	echo "DKP_ITEMS = {\n" ;
	foreach ( $player_data as $player => $player_values )
	{
			echo "     [\"". strto_wowutf($player) ."\"] = {\n";

			foreach ($player_values as $value_name => $value)
			{
			  if (is_array($value))
			  {
			    echo "          [\"$value_name\"] = {\n";
			    foreach ($value as $item_name => $item_cost)
			     {
			     $item_name = str_replace("?", "'", $item_name);
			     $item_name = strto_wowutf($item_name);
			     echo "               [\"$item_name\"] = $item_cost,\n";
			     }
			   echo "          },\n";
			   }
			   else
			   {
			     if (preg_match("/-?[.0-9]{1,7}/", $value))
				 {
			       // Is a number
			       echo "          [\"$value_name\"] = $value,\n";
				   }
				   else
				   {// Is a string
					 echo "          [\"$value_name\"] = \"$value\",\n";
				   }
				 }
			}

			echo "     },\n";
	}
	echo "}\n\n"; // End of DKP_ROLL_PLAYERS

################################################################
# Nonset
################################################################

// XXX: Unsupported -- mdg
if ($table_prefixNS <> "")
{

#	$sql = "SELECT
#			ra.member_name,
#			c.class_name as member_class,
#			m.member_earned + m.member_adjustment - m.member_spent as current_dkp
#		FROM
#			".$table_prefixNS."raids r, ".$table_prefixNS."raid_attendees ra, ".$table_prefixNS."members m, ".$table_prefixNS."classes c
#		WHERE
#			ra.raid_id = r.raid_id
#			AND m.member_name = ra.member_name
#			AND m.member_class_id = c.class_id
#		GROUP BY
#			ra.member_name
#		ORDER BY
#	member_name ASC";

$sql = "SELECT
		m.member_name,
        c.class_name as member_class,
		m.member_earned + m.member_adjustment - m.member_spent as current_dkp
	FROM
		".$table_prefixNS."members m, ".$table_prefixNS."classes c
	WHERE
		m.member_class_id = c.class_id
	GROUP BY
		m.member_name
	ORDER BY
member_name ASC";



	if ( !($result = $db->query($sql)) ) {
		print $sql ;
		message_die('Could not obtain member DKP information', '', __FILE__, __LINE__, $sql);
	}

	define(TAB, "\t");
	define(CRLF, "\r\n");

	$output = 'gdkp_NonSet = {'."\r\n";
	$output .=  TAB.'["players"] = {'.CRLF;
	$format =
		TAB.TAB.'["%s"] = {'.CRLF.
		TAB.TAB.TAB.'["dkp"] = %s,'.CRLF.
		TAB.TAB.TAB.'["class"] = "%s",'.CRLF.
		TAB.TAB.'},'.CRLF;

	while ($row = $db->fetch_record($result)) {
		$output .= sprintf($format,
			$row['member_name'],
			$row['current_dkp'],
			$row['member_class']
		);
	}

	$output = substr($output, 0, strlen($output)-3);
	echo $output.CRLF.TAB.'}'.CRLF.'}'.CRLF;

	$db->free_result($result);
}
// END XXX
?>
