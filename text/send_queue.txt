<?php
date_default_timezone_set("Asia/Dhaka");
include_once("include/header.php");
require 'vendor/autoload.php';
define("MQ_RECEIVE_ACCESS", 1);
define("MQ_DENY_NONE", 0);

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "queue_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$queuePath = ".\\private$\\messages";

try {
    $mq = new COM("MSMQ.MSMQQueueInfo");
    $mq->PathName = $queuePath;
    $queue = $mq->Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE);
} catch (Exception $e) {
    die("Failed to connect to MSMQ: " . $e->getMessage());
}

try {
    $msg = $queue->Receive();
    if ($msg) {
        $xml = $msg->Body;
        $xmlObj = simplexml_load_string($xml);

        $msisdn = (string) $xmlObj->msisdn;
        $text = (string) $xmlObj->text;
        $moid = (string) $xmlObj->moid;
        $telcoid = (string) $xmlObj->telcoid;
        $datetime = (string) $xmlObj->datetime;

        $stmt = $conn->prepare("INSERT INTO tbl_inbox (recvPhone, recvMsg, recvOriginatingID, recvSubsID, recvTelcoID, recvDate) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssss", $msisdn, $text, $moid, $msisdn, $telcoid, $datetime);

        if ($stmt->execute()) {
            echo "<div style='color: green; font-weight: bold; font-size: 24px; text-align: center; margin-top: 20%;'>Message processed and stored successfully</div>";
        } else {
            echo "Error: " . $stmt->error . "\n";
        }
    } else {
        echo "No messages available\n";
    }
} catch (Exception $e) {
    echo "Failed to retrieve message: " . $e->getMessage() . "\n";
}

$queue->Close();
$conn->close();

include_once("include/footer.php");
?>
