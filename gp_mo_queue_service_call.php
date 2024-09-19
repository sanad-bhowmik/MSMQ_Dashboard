<?php
header('Content-Type: application/xml');

// Read the raw POST data from the request body
$xmlData = file_get_contents('php://input');

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

$msisdnQ = "";
$textQ = "";
$msgidQ = "";
$telcoidQ = "";
$keywordQ = "";
$shortcodeQ = "";
$skeyQ = "";
$datetimeQ = "";
$urlFromDb = "";

if ($xmlData != NULL) {
    try {
        $xml = new SimpleXMLElement($xmlData);

        $msisdnQ = (string)$xml->msisdn;
        $textQ = (string)$xml->text;
        $msgidQ = (string)$xml->moid;
        $telcoidQ = (string)$xml->telcoid;
        $keywordQ = (string)$xml->keyword;
        $shortcodeQ = (string)$xml->shortcode;
        $skeyQ = (string)$xml->skey;
        $datetimeQ = (string)$xml->datetime;

        // Replace '+' with space in the keyword
        $keywordQ = str_replace('+', ' ', $keywordQ);

        // Log received data
        $logFilePath = "C:/mts/htdocs/msmq/log/gp/gp_mo_pull_queue_" . date('Y-m-d') . ".txt";
        $ftp2 = fopen($logFilePath, 'a+');
        fwrite($ftp2, "$msisdnQ - $textQ - $msgidQ - $keywordQ - $shortcodeQ - $skeyQ - " . date('Y-m-d H:i:s') . "\n");
        fclose($ftp2);

        // Queue forward block
        $keywordFromQueue = $keywordQ;
		if (strpos($keywordFromQueue, 'START ') === 0) {
		$keywordFromQueue = substr($keywordFromQueue, 6); 
		} elseif (strpos($keywordFromQueue, 'STOP ') === 0) {
		$keywordFromQueue = substr($keywordFromQueue, 5); 
		}
        $sql = $queueConn->prepare("SELECT urlResponse FROM tbl_keyword WHERE keyword = ?");
        $sql->bind_param("s", $keywordFromQueue);
        $sql->execute();
        $result = $sql->get_result();

        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $urlFromDb = $row['urlResponse'];

            $urlparam = "?msisdn=" . urlencode($msisdnQ) . "&msgid=" . urlencode($msgidQ) . "&telcoid=" . urlencode($telcoidQ) . "&skey=" . urlencode($skeyQ) . "&keyword=" . urlencode($keywordQ) . "&shortcode=" . urlencode($shortcodeQ) . "&text=" . urlencode($textQ);

            $urlToHit = $urlFromDb . $urlparam;

            // Log URL to hit
            $urlLogFilePath = "C:/mts/htdocs/msmq/log/gp/url_hiting_log_" . date('Y-m-d') . ".txt";
            $ftp3 = fopen($urlLogFilePath, 'a+');
            fwrite($ftp3, "$urlToHit " . date('Y-m-d H:i:s') . "\n");
            fclose($ftp3);

            try {
                $response = HttpRequest($urlFromDb, $urlparam);

                if ($response == 408) {
                    // Log failed attempt
                    $failLogFilePath = "C:/mts/htdocs/msmq/log/gp/gp_Push_failed_log_" . date('Y-m-d') . ".txt";
                    $ftp2 = fopen($failLogFilePath, 'a+');
                    fwrite($ftp2, "$urlFromDb $urlparam --- " . date('Y-m-d H:i:s') . "\n");
                    fclose($ftp2);
                    echo 408;
                } else {
                    
                        // Insert new record
                        $stmt = $queueConn->prepare("INSERT INTO tbl_inbox (recvPhone, recvMsg, recvOriginatingID, recvSubsID, recvTelcoID, recvDate) VALUES (?, ?, ?, ?, ?, ?)");
                        $stmt->bind_param("ssssss", $msisdnQ, $textQ, $msgidQ, $msisdnQ, $telcoidQ, $datetimeQ);

                        if ($stmt->execute()) {
                            echo "Record inserted successfully";
                        } else {
                            echo "Error: " . $stmt->error;
                        }
                    $stmtCheck->close();
                }
            } catch (Exception $e) {
                echo 500;
            }
        } else {
            // Log invalid keyword
            $wrongKeyLogFilePath = "C:/mts/htdocs/msmq/log/gp/gp_mo_pull_worng_key_queue_" . date('Y-m-d') . ".txt";
            $ftp2 = fopen($wrongKeyLogFilePath, 'a+');
            fwrite($ftp2, "$msisdnQ - $textQ - $msgidQ - $keywordQ - $shortcodeQ - $skeyQ - " . date('Y-m-d H:i:s') . "\n");
            fclose($ftp2);
            echo 400;
        }
    } catch (Exception $e) {
        echo 404;
    }
} else {
    echo 404;
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
?>
