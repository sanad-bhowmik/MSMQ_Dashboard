<?php
if (!defined('MQ_RECEIVE_ACCESS')) {
    define("MQ_RECEIVE_ACCESS", 1);
}
if (!defined('MQ_DENY_NONE')) {
    define("MQ_DENY_NONE", 0);
}

function fetchMessageFromQueue() {
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
            $keyword = $xml->keyword;
            $shortcode = $xml->shortcode;
            $datetime = $xml->datetime;

            echo "<ul>";
            echo "<li><strong>MSISDN:</strong> $msisdn</li>";
            echo "<li><strong>Text:</strong> $text</li>";
            echo "<li><strong>Message ID:</strong> $msgid</li>";
            echo "<li><strong>Telco ID:</strong> $telcoid</li>";
            echo "<li><strong>Keyword:</strong> $keyword</li>";
            echo "<li><strong>Shortcode:</strong> $shortcode</li>";
            echo "<li><strong>Datetime:</strong> $datetime</li>";
            echo "</ul>";

            return $keyword;
        } else {
            echo "<p>No messages in queue.</p>";
            return null;
        }

        $msgQueue->Close();
        unset($msgQueueInfo);
    } catch (Exception $e) {
        echo "<div style='color: red; font-weight: bold; font-size: 16px;'>An error occurred: " . $e->getMessage() . "</div>";
        return null;
    }
}
?>
