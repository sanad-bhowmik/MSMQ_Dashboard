<?php
if (!defined('MQ_RECEIVE_ACCESS')) {
    define("MQ_RECEIVE_ACCESS", 1);
}
if (!defined('MQ_DENY_NONE')) {
    define("MQ_DENY_NONE", 0);
}

$msisdnQ = "";
$textQ = "";
$msgidQ = "";
$telcoidQ = "";
$keywordQ = "";
$shortcodeQ = "";
$datetimeQ = "";


try {
    $msgQueueInfo = new COM("MSMQ.MSMQQueueInfo");
    $msgQueueInfo->PathName = ".\\private$\\messages";

    $msgQueue = $msgQueueInfo->Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE);

    if (!$msgQueue) {
        throw new Exception("Failed to open the queue.");
    }

    //$msgQueue->Reset();
    //  print_r($msgQueue->PeekNext());
    // Check message count
    //$msgCount = $msgQueue->MessagesToReceive();

    try {
        $msg = $msgQueue->PeekFirstByLookupId();
        if ($msg != NULL) {
            //$msg = $msgQueue->Receive();
        }
    } catch (Exception $e) {
        echo $e;
    }





    if ($msg) {
        $xmlString = $msg->Body;
        $xml = new SimpleXMLElement($xmlString);

        $msisdnQ = $xml->msisdn;
        $textQ = $xml->text;
        $msgidQ = $xml->msgid;
        $telcoidQ = $xml->telcoid;
        $keywordQ = $xml->keyword;
        $shortcodeQ = $xml->shortcode;
        $datetimeQ = $xml->datetime;

        echo "<ul>";
        echo "<li><strong>MSISDN:</strong> $msisdnQ</li>";
        echo "<li><strong>Text:</strong> $textQ</li>";
        echo "<li><strong>Message ID:</strong> $msgidQ</li>";
        echo "<li><strong>Telco ID:</strong> $telcoidQ</li>";
        echo "<li><strong>Keyword:</strong> $keywordQ</li>";
        echo "<li><strong>Shortcode:</strong> $shortcodeQ</li>";
        echo "<li><strong>Datetime:</strong> $datetimeQ</li>";
        echo "</ul>";

        // return $keyword;
    } else {
        echo "<p>No messages in queue.</p>";
        // return null;
    }

    $msgQueue->Close();
    unset($msgQueueInfo);
} catch (Exception $e) {
    echo "<div style='color: red; font-weight: bold; font-size: 16px;'>An error occurred: " . $e->getMessage() . "</div>";
    // return null;
}
?>