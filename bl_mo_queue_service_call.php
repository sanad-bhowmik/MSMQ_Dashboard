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


    $xml = new SimpleXMLElement($xmlData);


    $msisdnQ = $xml->msisdn;
    $textQ = $xml->text;
    $msgidQ = $xml->moid;
    $telcoidQ = $xml->telcoid;
    $keywordQ = $xml->keyword;
    $shortcodeQ = $xml->shortcode;
    $datetimeQ = $xml->datetime;



    $ftp2 = fopen("C:/mts/htdocs/msmq/log/bl/bl_mo_pull_queue_" . date('Y-m-d') . ".txt", 'a+');
    fwrite($ftp2, $msisdnQ . "-" . $textQ . "-" . $msgidQ . "-" . $keywordQ . "-" . $shortcodeQ . "-" . date('Y-m-d H:i:s') . "\n");
    fclose($ftp2);


    //die();
    //
    // queue forward block
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

        $urlparam =  "?msisdn=" . $msisdnQ . "&msgid=" . $msgidQ . "&telcoid=" . $telcoidQ . "&keyword=" . urlencode($keywordQ) . "&shortcode=" . $shortcodeQ . "&text=" . urlencode($textQ);

        $urlToHit = $urlFromDb  . $urlparam;

        $ftp3 = fopen("C:/mts/htdocs/msmq/log/bl/url_hiting_log_" . date('Y-m-d') . ".txt", 'a+');
        fwrite($ftp3, $urlToHit . " " . date('Y-m-d H:i:s') . "\n");

        fclose($ftp3);
        try {
            $ftp2 = fopen("C:/mts/htdocs/msmq/log/bl/bl_Push_log_" . date('Y-m-d') . ".txt", 'a+');
            fwrite($ftp2, $urlFromDb . $urlparam . "---" . date('Y-m-d H:i:s') . "\n");

            fclose($ftp2);
            $response = HttpRequest($urlFromDb, $urlparam);

            if ($response == 408) {

                echo 408;
                $ftp2 = fopen("C:/mts/htdocs/msmq/log/bl/bl_Push_failed_log_" . date('Y-m-d') . ".txt", 'a+');
                fwrite($ftp2, $urlFromDb . $urlparam . "---" . date('Y-m-d H:i:s') . "\n");

                fclose($ftp2);
            } else {


                $stmt = $queueConn->prepare("INSERT INTO tbl_inbox (recvPhone, recvMsg, recvOriginatingID, recvSubsID, recvTelcoID, recvDate) VALUES (?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("ssssss", $msisdnQ, $textQ, $moidQ, $msisdnQ, $telcoidQ, $datetimeQ);

                if ($stmt->execute()) {
                    echo "Record inserted successfully";
                    $queueConn->close();
                } else {
                    echo "Error: " . $stmt->error;
                }
            } // try url hit

        } catch (Exception $e) {
            echo 500;
        }
    } // if num rows
    else {

        $ftp2 = fopen("C:/mts/htdocs/msmq/log/bl/bl_mo_pull_worng_key_queue_" . date('Y-m-d') . ".txt", 'a+');
        fwrite($ftp2, $msisdnQ . "-" . $textQ . "-" . $msgidQ . "-" . $keywordQ . "-" . $shortcodeQ . "-" . $skeyQ . "-" . date('Y-m-d H:i:s') . "\n");
        fclose($ftp2);
        echo 400;

        //  exit;
    }
} // no xml 
else {
    $ftp2 = fopen("C:/mts/htdocs/msmq/log/bl/bl_mo_pull_queue_" . date('Y-m-d') . ".txt", 'a+');
    fwrite($ftp2,  date('Y-m-d H:i:s') . "\n");
    fclose($ftp2);
    echo 404;
}

//$queueConn->close();

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
