<?php
date_default_timezone_set("Asia/Dhaka");

// Define MSMQ constants
define('MQ_RECEIVE_ACCESS', 1);
define('MQ_DENY_NONE', 0);

try {
    $queueName = ".\\Private$\\messages"; 
    $queueInfo = new COM("MSMQ.MSMQQueueInfo");
    $queueInfo->PathName = $queueName;
    $queue = $queueInfo->Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE);

    $message = $queue->Receive();
    if ($message) {
        $xmlMessage = $message->Body;
    } else {
        die("No message in queue");
    }

    $queue->Close();
} catch (Exception $e) {
    die("Error: " . $e->getMessage());
}

$xml = simplexml_load_string($xmlMessage);
$keyword = (string)$xml->keyword;

$mysqli = new mysqli("localhost", "root", "", "queue_db");

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

$stmt = $mysqli->prepare("SELECT urlResponse FROM tbl_keyword WHERE keyword = ?");
$stmt->bind_param("s", $keyword);
$stmt->execute();
$stmt->bind_result($urlResponse);

if ($stmt->fetch()) {
    $stmt->close();
    $mysqli->close();
    
    echo "<script>window.open('$urlResponse', '_blank');</script>";
    exit;
} else {
    $message = "No matching keyword found.";
}

$stmt->close();
$mysqli->close();

include_once("include/initialize.php");
include_once("include/header.php");

if (isset($message)) {
    echo $message;
}

include_once("include/footer.php");
?>
