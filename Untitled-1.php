<?php

date_default_timezone_set('Asia/Dhaka');
$date = date('Y-m-d h:i A');
$datenew = date('Y-m-d');
$newtext = file_get_contents('php://input');
define('MQ_RECEIVE_ACCESS', 1);
define('MQ_SEND_ACCESS', 2);
define('MQ_DENY_NONE', 0);


// Database connection
$queueDbServername = "localhost";
$queueDbUsername = "root";
$queueDbPassword = "";
$queueDbName = "queue_db";

$queueConn = new mysqli($queueDbServername, $queueDbUsername, $queueDbPassword, $queueDbName);

if ($queueConn->connect_error) {
    die("Connection failed: " . $queueConn->connect_error);
}

if (!defined('MQ_RECEIVE_ACCESS')) {
    define("MQ_RECEIVE_ACCESS", 1);
}
if (!defined('MQ_DENY_NONE')) {
    define("MQ_DENY_NONE", 0);
}

// Gather input data
$msisdn = isset($_GET['msisdn']) ? $_GET['msisdn'] : '';
$text = isset($_GET['text']) ? $_GET['text'] : '';
$keyword = isset($_GET['keyword']) ? $_GET['keyword'] : '';
$moid = isset($_GET['moid']) ? $_GET['moid'] : '';
$shortcode = isset($_GET['shortcode']) ? $_GET['shortcode'] : '';
$telcoid = isset($_GET['telcoid']) ? $_GET['telcoid'] : '';

$ftp = fopen("Log/Request_Hit_" . $datenew . ".txt", 'a+');
fwrite($ftp, "msisdn: $msisdn, text: $text, keyword: $keyword, moid: $moid, shortcode: $shortcode, telcoid: $telcoid - " . $date . "\n");
fclose($ftp);

// Prepare XML data
$xml = new SimpleXMLElement('<root/>');
$xml->addChild('msisdn', $msisdn);
$xml->addChild('text', $text);
$xml->addChild('moid', $moid);
$xml->addChild('telcoid', $telcoid);
$xml->addChild('shortcode', $shortcode);
$xml->addChild('datetime', date("Y-m-d H:i:s"));
$xml->addChild('keyword', $keyword);

$xmlString = $xml->asXML();


$ftp2 = fopen("Log/XML_Queue_Hit_" . $datenew . ".txt", 'a+');
fwrite($ftp2, "XML: $xmlString - " . $date . "\n");
fclose($ftp2);


$queuePath = ".\\Private$\\gp_messages";
AddToQueue($queuePath, $xmlString);


function AddToQueue($queuePath, $xmlData)
{
    try {
        $queueInfo = new COM("MSMQ.MSMQQueueInfo");
        $queueInfo->PathName = $queuePath;

        $queue = $queueInfo->Open(MQ_SEND_ACCESS, MQ_DENY_NONE);

        $msg = new COM("MSMQ.MSMQMessage");
        $msg->Body = $xmlData;
        $msg->Label = "SMS Data";

        $msg->Send($queue);

        $queue->Close();

        echo "Response Status Code: 200 - Message added to the queue successfully.";
    } catch (Exception $e) {
        error_log("Queue Error: " . $e->getMessage());
        echo "Error adding message to the queue: " . $e->getMessage();
    }
}
// Close database connection
mysqli_close($queueConn);
?>