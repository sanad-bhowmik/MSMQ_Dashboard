<?php
include_once("fetch_queue.php");

$keywordFromQueue = $keywordQ;

$queueDbServername = "localhost";
$queueDbUsername = "root";
$queueDbPassword = "";
$queueDbName = "queue_db";

$queueConn = new mysqli($queueDbServername, $queueDbUsername, $queueDbPassword, $queueDbName);

if ($queueConn->connect_error) {
    die("Connection failed: " . $queueConn->connect_error);
}

$sql = $queueConn->prepare("SELECT urlResponse FROM tbl_keyword WHERE keyword = ?");
$sql->bind_param("s", $keywordFromQueue);
$sql->execute();
$result = $sql->get_result();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $urlFromDb = $row['urlResponse'];
    }
} else {
    echo "No URL found for the keyword: " . htmlspecialchars($keywordFromQueue);
    $queueConn->close();
    exit;
}

$queueConn->close();
$urlparam =  "?msisdn=" . $msisdnQ."&msgid=" . $msgidQ . "&telcoid=" . $telcoidQ . "&keyword=" . $keywordQ . "&shortcode=" . $shortcodeQ . "&text=" . urlencode($textQ) ;

$urlToHit = $urlFromDb."?".$urlparam; 
echo "URL to hit: " . $urlToHit . "<br>";

$response = HttpRequest($urlFromDb,$urlparam);
var_dump($response);

$urlForMt = "http://103.228.39.37:88/smsPanel/mt.php?sms=" . urlencode($response);
echo "URL for MT: " . $urlForMt . "<br>";

$response2 = file_get_contents($urlForMt);
var_dump($response2);


function HttpRequest($url,$param) { 
    $URL_STR =$url.$param;
    $ch=curl_init();
    curl_setopt($ch,CURLOPT_URL,$URL_STR);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER,false);
    curl_exec($ch);
    $response = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $response;
} 
?>