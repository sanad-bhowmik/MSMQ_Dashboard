<?php
$rd = "test" . rand();
$content = $_REQUEST['content'];
$msisdn = $_REQUEST['msisdn'];
//$promsisdn = substr($msisdn,0,5);
// db block
date_default_timezone_set('Asia/Dhaka');
$queueDbServername = "localhost";
$queueDbUsername = "root";
$queueDbPassword = "";
$queueDbName = "queue_db";

$queueConn = new mysqli($queueDbServername, $queueDbUsername, $queueDbPassword, $queueDbName);

if ($queueConn->connect_error) {
    die("Connection failed: " . $queueConn->connect_error);
}
// db block

$contentsession = $_REQUEST['contentsession'];
if (isset($_REQUEST['serviceidentifier'])) {
    $serviceidentifier = $_REQUEST['serviceidentifier'];
}
$skey = $_REQUEST['skey'];
if (isset($_REQUEST['chargecode'])) {
    $chargecode = $_REQUEST['chargecode'];
}
if (isset($_REQUEST['shortcode'])) {
    $shortcode = $_REQUEST['shortcode'];
}

$ln = "EN";
$maint = "Text";

$json_string2 = array(
    "accesInfo" => array(
        "servicekey" => $skey,
        "endUserId" => $msisdn,
        "accesschannel" => "MTSMS",
        "referenceCode" => $rd

    ),

    "smsInfo" => array(
        "msgTransactionId" => $contentsession,
        "language" => "EN",
        "senderId" => "16658",
        "message" => $content,
        "msgType" => "Text",
        "validity" => "1",
        "deliveryReport" => "1"

    )
);

if ($skey == "41447092a5674814826cedb2f404230d") {
    $json_string2 = array(
        "accesInfo" => array(
            "servicekey" => $skey,
            "endUserId" => $msisdn,
            "accesschannel" => "MTSMS",
            "referenceCode" => $rd

        ),
        "charge" => array(
            "code" => "PPU0005880001122661636",
            "amount" => "1.0",
            "taxAmount" => "0.0",
            "description" => "Test",
            "currency" => "BDT"

        ),
        "smsInfo" => array(
            "msgTransactionId" => $contentsession,
            "language" => "EN",
            "senderId" => "16658",
            "message" => $content,
            "msgType" => "Text",
            "validity" => "1",
            "deliveryReport" => "1"

        )
    );
}


// Outbox Message
$telcoid = '1';
$datetime = date('Y-m-d H:i:s');

$outbox = $queueConn->prepare("INSERT INTO tbl_outbox (msgTo, msgText, msgMOid, msgMTid, msgTelcoID, msgDate) VALUES (?, ?, ?, ?, ?, ?)");
$outbox->bind_param("ssssss", $msisdn, $content, $contentsession, $rd, $telcoid, $datetime);
// Outbox Message



$json_data    = json_encode($json_string2);
$ftp = fopen("Log/jsonlog.txt", 'a+');
fwrite($ftp, $json_data . "\n");
fclose($ftp);
$request_url        = "https://10.21.11.16:9098/digital5/messaging/v5.0/sendsms";

$headers = array(
    "Content-Type: application/json"
);

///closed By Sagar//////
$datenew = date("Y-m-d");
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $request_url);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
$response_body        = curl_exec($ch);
$response_header     = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$date = date('Y-m-d h:i A');
$datenn = date('Y-m-d H:i:s');
$ftp = fopen("Log/mo_mt_log_" . $datenew . ".txt", 'a+');
fwrite($ftp, $json_data . "\n");
fwrite($ftp, $response_body . " " . $response_header . "-" . $content . "-" . $shortcode . " " . $datenn . "\n");

fclose($ftp);

$ftp2 = fopen("Log/iod_json_" . $datenew . ".txt", 'a+');
fwrite($ftp2, $json_data . "\n");
fclose($ftp2);
$newtextjson = json_decode($response_body);
//$notify = $newtextjson->statusInfo;
//$rr = $notify->statusCode;
