<?php


$dbhost="localhost";
$dbusername="root";
$dbpassword="";
$dbname="queue_db";


/* 
$dbhost="128.199.224.35";
$dbusername="jjupxrppwp";
$dbpassword="qwUA3fxhXR";
$dbname="jjupxrppwp";
 */

$GLOBALS['con'] = mysqli_connect($dbhost,$dbusername,$dbpassword,$dbname);


if(mysqli_connect_errno()){


	die ("error: ".mysqli_connect_errno());

}




?>