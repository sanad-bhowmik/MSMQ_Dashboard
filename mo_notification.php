<?php
error_reporting(0);
date_default_timezone_set('Asia/Dhaka');
$date = date('Y-m-d h:i A');
$datenew = date('Y-m-d');
$newtext = file_get_contents('php://input');
include "db.php";


$txt = html_entity_decode($newtext);
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


$msisdn = isset($_GET['msisdn']) ? $_GET['msisdn'] : '';
$text = isset($_GET['text']) ? $_GET['text'] : '';
$keyword = isset($_GET['keyword']) ? $_GET['keyword'] : '';
$moid = isset($_GET['moid']) ? $_GET['moid'] : '';
$shortcode = isset($_GET['shortcode']) ? $_GET['shortcode'] : '';
$telcoid = isset($_GET['telcoid']) ? $_GET['telcoid'] : '';

$ftp = fopen("Log/Request_Hit_" . $datenew . ".txt", 'a+');
fwrite($ftp, "msisdn: $msisdn, text: $text, keyword: $keyword, moid: $moid, shortcode: $shortcode, telcoid: $telcoid - " . $date . "\n");
fclose($ftp);

$query = "SELECT urlResponse FROM tbl_keyword WHERE keyword = ? LIMIT 1";
$stmt = $con->prepare($query);
$stmt->bind_param("s", $keyword);
$stmt->execute();
$stmt->bind_result($urlResponse);
$stmt->fetch();
$stmt->close();

if ($urlResponse) {
    $xml = new SimpleXMLElement('<root/>');
    $xml->addChild('msisdn', $msisdn);
    $xml->addChild('text', $text);
    $xml->addChild('moid', $moid);
    $xml->addChild('telcoid', $telcoid);
    $xml->addChild('shortcode', $shortcode);
    $xml->addChild('datetime', date("Y-m-d H:i:s"));
    $xml->addChild('keyword', $keyword);

    $xmlString = $xml->asXML();

    $ftp2 = fopen("Log/URL_Hit_" . $datenew . ".txt", 'a+');
    fwrite($ftp2, "URL: $urlResponse, XML: $xmlString - " . $date . "\n");
    fclose($ftp2);

    $response = HttpRequest($urlResponse, $xmlString);
    echo "Response from URL: " . $response;
} else {
    echo "Keyword not found in database.";
}

// Function to send HTTP request
function HttpRequest($url, $xmlData)
{
    try {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $xmlData);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/xml'));
        $response = curl_exec($ch);
        curl_close($ch);
        return $response;
    } catch (Exception $e) {
        error_log("HTTP Request Error: " . $e->getMessage());
        return "Error: " . $e->getMessage();
    }
}

// Close database connection
mysqli_close($con);
