<?php
error_reporting(0);

$date = date('Y-m-d h:i A');
$datenew = date('Y-m-d');
$newtext = file_get_contents('php://input');
//$newtext='{"notify":{"accesInfo":{"endUserId":"576834542256843538","serverReferenceCode":"3010211151505890884263535","language":"EN","accesschannel":"SMS"},"smsInfo":{"totalAmountCharged":"0","msgType":"SMSTEXT","productIdentifier":"3602","msgTransactionId":"3010211151505890884263535","servcieIdentifier":"PPU00026402668","shortcode":"19283","message":"EW 2"}}}';

include "db.php";

$txt =  html_entity_decode($newtext);
$newtextjson = json_decode($txt);
$notify = $newtextjson->notify;

$accesInfo = $notify->accesInfo;
$smsInfo = $notify->smsInfo;

$endUserId = $accesInfo->endUserId;

$language = $accesInfo->language;
$accesschannel = $accesInfo->accesschannel;
$serverReferenceCode = $accesInfo->serverReferenceCode;

$servcieIdentifier = $smsInfo->servcieIdentifier;
$productIdentifier = $smsInfo->productIdentifier;
$msgTransactionId = $smsInfo->msgTransactionId;
$shortcode = $smsInfo->shortcode;
$message = $smsInfo->message;


$ftp = fopen("Log/Server_Hit_" . $datenew . ".txt", 'a+');
fwrite($ftp, $txt . "-" . $date . "\n");
fwrite($ftp, $endUserId . "-LN-" . $language . "-TXID-" . $msgTransactionId . "-SVCID" . $servcieIdentifier . "-" . $date . "\n");
fclose($ftp);




$selct = "select * from tbl_gp_keyword where service_id='$servcieIdentifier' AND service_type='PPU' limit 1";
$res = mysqli_query($con, $selct);
$row = mysqli_fetch_array($res, MYSQLI_ASSOC);
$skey = $row["service_key"];
$keyword = $row["keyword"];


$maincon = urlencode($message);

$msgType = $smsInfo->msgType;

$totalAmountCharged = $smsInfo->totalAmountCharged;


//$skey = "df428e7a306d48259e4ced7098cdf64c";
$rowcount = mysqli_num_rows($res);
if ($rowcount > 0) {
    $registerMO_url = 'http://localhost:9090/iod_mt_mtips.php';
    $msisdn = $endUserId;
    $datekk = date("Y-m-d H:i:s");
    $content = "MT Content for key-" . $keyword;
    $content = urlencode($content);
    $registerMO_param = "?content=$content&msisdn=$msisdn&contentsession=$msgTransactionId&skey=$skey&shortcode=19283&telcoid=1";
    $ftp2 = fopen("Log/mo_log_" . $datenew . ".txt", 'a+');
    fwrite($ftp2, $datekk . "-" . $registerMO_param . "-" . $servcieIdentifier . "\n");
    fclose($ftp2);

    $response2    = HttpRequest($registerMO_url, $registerMO_param);
}

function HttpPOST($url, $param)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $param);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/soap+xml;charset=UTF-8'));
    $response_body = curl_exec($ch);
    $response_header = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $response_body;
}
function HttpRequest($url, $param)
{
    $URL_STR = $url . $param;
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $URL_STR);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, false);
    curl_exec($ch);
    $response = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $response;
}

// Free result set
mysqli_free_result($res);

mysqli_close($con);
?>