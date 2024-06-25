<?php
include_once("include/initialize.php");
date_default_timezone_set("Asia/Dhaka");
include_once("include/header.php");
require 'vendor/autoload.php';
define("MQ_RECEIVE_ACCESS", 1);
define("MQ_DENY_NONE", 0);

try {
    $msgQueueInfo = new COM("MSMQ.MSMQQueueInfo");
    $msgQueueInfo->PathName = ".\\private$\\messages";

    $msgQueue = $msgQueueInfo->Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE);
    if (!$msgQueue) {
        throw new Exception("Failed to open the queue.");
    }

    $msg = $msgQueue->Receive();
    if ($msg) {
        $xmlString = $msg->Body;
        $xml = new SimpleXMLElement($xmlString);

        $msisdn = $xml->msisdn;
        $text = $xml->text;
        $msgid = $xml->msgid;
        $telcoid = $xml->telcoid;
        $shortcode = $xml->shortcode;
        $datetime = $xml->datetime;

        echo "<ul>";
        echo "<li><strong>MSISDN:</strong> $msisdn</li>";
        echo "<li><strong>Text:</strong> $text</li>";
        echo "<li><strong>Message ID:</strong> $msgid</li>";
        echo "<li><strong>Telco ID:</strong> $telcoid</li>";
        echo "<li><strong>Shortcode:</strong> $shortcode</li>";
        echo "<li><strong>Datetime:</strong> $datetime</li>";
        echo "</ul>";
    } else {
        echo "<p>No messages in queue.</p>";
    }

    $msgQueue->Close();
    unset($msgQueueInfo);
} catch (Exception $e) {
    echo "<div style='color: red; font-weight: bold; font-size: 16px;'>An error occurred: " . $e->getMessage() . "</div>";
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Queue Display</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        #message {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }

        ul {
            list-style-type: none;
            padding: 0;
        }

        ul li {
            margin-bottom: 10px;
        }

        ul li strong {
            font-weight: bold;
            margin-right: 5px;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>Latest Message from Queue</h1>
        <div id="message">
            <?php include 'fetch_queue.php'; ?>
        </div>
    </div>
</body>

</html>


<?php
include_once("include/footer.php");
?>