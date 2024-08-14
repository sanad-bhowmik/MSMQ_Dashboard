<?php
// db block
date_default_timezone_set('Asia/Dhaka');
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
    $msgQueueInfo->PathName = ".\\private$\\gp_messages";

    $msgQueue = $msgQueueInfo->Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE);

    if (!$msgQueue) {
        throw new Exception("Failed to open the queue.");
    }

    try {
        $msg = $msgQueue->PeekFirstByLookupId();
        if ($msg != NULL) {
			
		
            if ($msg) {
                $xmlString = $msg->Body;
                $xml = new SimpleXMLElement($xmlString);

                $msisdnQ = $xml->msisdn;
                $textQ = $xml->text;
                $msgidQ = $xml->moid;
                $telcoidQ = $xml->telcoid;
                $keywordQ = $xml->keyword;
                $shortcodeQ = $xml->shortcode;
                $datetimeQ = $xml->datetime;
            }
			
				//log
				//$logDir = 'C:\\mts\\htdocs\\msmq\\log\\mo_pull_queue\\';
				//$logFileName = $logDir . 'mo_pull_queue' . date('Ymd') . '.txt';
				
				
			$ftp2 = fopen("C:/mts/htdocs/msmq/log/gp_mo_pull_queue_" .date('Y-m-d').".txt", 'a+');
            fwrite($ftp2, $msisdnQ . "-" . $textQ . "-".$msgidQ ."-".$keywordQ."-".$shortcodeQ."-".date('Y-m-d H:i:s')."\n");
           
            fclose($ftp2);
		
				//
			
			
            // queue forward block
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
				$msg = $msgQueue->Receive();
                echo 400;
               // $queueConn->close();
                exit;
            }

            $urlparam =  "?msisdn=" . $msisdnQ . "&msgid=" . $msgidQ . "&telcoid=" . $telcoidQ . "&keyword=" . $keywordQ . "&shortcode=" . $shortcodeQ . "&text=" . urlencode($textQ);

            $urlToHit = $urlFromDb . "?" . $urlparam;

            try {
                $response = HttpRequest($urlFromDb, $urlparam);
                if ($response == 408) {
                    echo 408;
                } else {
                    $msg = $msgQueue->Receive();

                    // Add database insert here
                    $xml = $msg->Body;
                    $xmlObj = simplexml_load_string($xml);

                    $msisdn = (string) $xmlObj->msisdn;
                    $text = (string) $xmlObj->text;
                    $moid = (string) $xmlObj->moid;
                    $telcoid = (string) $xmlObj->telcoid;
                    $datetime = (string) $xmlObj->datetime;

                    $stmt = $queueConn->prepare("INSERT INTO tbl_inbox (recvPhone, recvMsg, recvOriginatingID, recvSubsID, recvTelcoID, recvDate) VALUES (?, ?, ?, ?, ?, ?)");
                    $stmt->bind_param("ssssss", $msisdn, $text, $moid, $msisdn, $telcoid, $datetime);

                    if ($stmt->execute()) {
                        echo "Record inserted successfully";
                    } else {
                        echo "Error: " . $stmt->error;
                    }
                }
            } catch (Exception $e) {
                echo 500;
            }
        } else {
            echo 404;
        }
    } catch (Exception $e) {
        echo 500;
    }

    $msgQueue->Close();
    unset($msgQueueInfo);
} catch (Exception $e) {
    echo 500;
}

$queueConn->close();

function HttpRequest($url, $param)
{
    $URL_STR = $url . $param;
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $URL_STR);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, false);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5); // Set timeout to 5 seconds
    curl_exec($ch);
    $response = curl_errno($ch) == CURLE_OPERATION_TIMEDOUT ? 408 : curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $response;
}
