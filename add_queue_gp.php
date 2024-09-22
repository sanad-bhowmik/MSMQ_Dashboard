<?php
date_default_timezone_set("Asia/Dhaka");
$datetime = date('Y-m-d H:i:s');
$date = date('Y-m-d');

// Include the necessary initialization file
include_once("include/initialize.php");

// Initialize variables
$msisdn = "not found";
$text = "not found";
$moid = "not found";
$telcoid = "not found";
$keyword = "not found";
$shortcode = "not found";
$sKey = "not found";
$ip = "";

// Get the IP address
if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ip = $_SERVER['HTTP_CLIENT_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
} else {
    $ip = $_SERVER['REMOTE_ADDR'];
}

// Get request parameters
if (isset($_REQUEST['msisdn'])) {
    $msisdn = $_REQUEST['msisdn'];
}
if (isset($_REQUEST['text'])) {
    $text = $_REQUEST['text'];
}
if (isset($_REQUEST['moid'])) {
    $moid = $_REQUEST['moid'];
}
if (isset($_REQUEST['telcoid'])) {
    $telcoid = $_REQUEST['telcoid'];
}
if (isset($_REQUEST['shortcode'])) {
    $shortcode = $_REQUEST['shortcode'];
}
if (isset($_REQUEST['keyword'])) {
    $keyword = $_REQUEST['keyword'];
}
if (isset($_REQUEST['skey'])) {
    $sKey = $_REQUEST['skey'];
}

// Prepare log data
$logdata = "msisdn: " . $msisdn;
$logdata .= " text: " . $text;
$logdata .= " moid: " . $moid;
$logdata .= " telcoid: " . $telcoid;
$logdata .= " shortcode: " . $shortcode;
$logdata .= " reqip: " . $ip;
$logdata .= " datetime: " . $datetime;
$logdata .= " keyword: " . $keyword;
$logdata .= " Skeyword: " . $sKey;
$logdata .= "\n";


// Prepare XML data
$xml = new SimpleXMLElement('<Message/>');
$xml->addChild('msisdn', $msisdn);
$xml->addChild('text', $text);
$xml->addChild('moid', $moid);
$xml->addChild('telcoid', $telcoid);
$xml->addChild('shortcode', $shortcode);
$xml->addChild('datetime', $datetime);
$xml->addChild('keyword', $keyword);
$xml->addChild('skey', $sKey);
$xmlString = $xml->asXML();

define("MQ_SEND_ACCESS", 2);
define("MQ_DENY_NONE", 0);

try {
    $msgQueueInfo = new COM("MSMQ.MSMQQueueInfo");
    $msgQueueInfo->PathName = ".\\private$\\gp_queues";

    $msgQueue = $msgQueueInfo->Open(MQ_SEND_ACCESS, MQ_DENY_NONE);
    if (!$msgQueue) {
        throw new Exception("Failed to open the queue.");
    }

    $msgOut = new COM("MSMQ.MSMQMessage");
    $msgOut->Body = $xmlString;
    $msgOut->Label = "GPmessage";
    $msgOut->Send($msgQueue);

    $msgQueue->Close();
    unset($msgOut);
    unset($msgQueue);
    unset($msgQueueInfo);

    echo "<div style='text-align: center; margin-top: 10px;'>Response Status Code: 200</div>";
} catch (Exception $e) {
    // Log the error
    $errorLogData = "Error occurred: " . $e->getMessage() . " Data: " . $xmlString;
    file_put_contents($logFilePath, $errorLogData, FILE_APPEND | LOCK_EX);

    echo "<div style='color: red; font-weight: bold; font-size: 24px; text-align: center; margin-top: 20%;'>An error occurred: " . $e->getMessage() . "</div>";
}

exit;
?>
