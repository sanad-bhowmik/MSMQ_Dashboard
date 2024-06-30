<?php
// db block
$queueDbServername = "localhost";
$queueDbUsername = "root";
$queueDbPassword = "";
$queueDbName = "queue_db";

$queueConn = new mysqli($queueDbServername, $queueDbUsername, $queueDbPassword, $queueDbName);

if ($queueConn->connect_error) {
    die("Connection failed: " . $queueConn->connect_error);
}
// db block

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
$urlFromDb = "";

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
            }
            // quqeue forward block
            $keywordFromQueue = $keywordQ;

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
            $urlparam =  "?msisdn=" . $msisdnQ . "&msgid=" . $msgidQ . "&telcoid=" . $telcoidQ . "&keyword=" . $keywordQ . "&shortcode=" . $shortcodeQ . "&text=" . urlencode($textQ);

            $urlToHit = $urlFromDb . "?" . $urlparam;
            echo "URL to hit: " . $urlToHit . "<br>";

            try {
                $response = HttpRequest($urlFromDb, $urlparam);
                var_dump($response);

                $msg = $msgQueue->Receive();
            } catch (Exception $e) {
            }

            // queue forward block end


        }
    } catch (Exception $e) {
        echo $e;
    }



    $msgQueue->Close();
    unset($msgQueueInfo);
} catch (Exception $e) {
    echo "" . $e->getMessage() . "";
    // return null;
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
