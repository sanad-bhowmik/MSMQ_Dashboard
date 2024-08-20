<html>
<head>
<meta charset ="utf-8">
</head>
<body><?php

date_default_timezone_set("Asia/Thimphu");
$datenew=date('Y-m-d');
$datenew2=date('Y-m-d H:i:s');

$to = $_REQUEST["msisdn"];
$message = urldecode($_REQUEST["message"]);
$message2 = $message;
echo $_REQUEST["message"];

$ftp =   fopen("gp_mt_log".$datenew.".txt",'a+');
        fwrite($ftp,$to."-".$message2." ".$datenew."-".$datenew2."\n");
        fclose($ftp);



?>
</body>
</html>


