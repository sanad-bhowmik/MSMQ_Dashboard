<?php
error_reporting(0);
date_default_timezone_set('Asia/Dhaka');
$date = date('Y-m-d h:i A');
$datenew = date('Y-m-d');
$newtext = file_get_contents('php://input');
//$newtext='{"notify":{"accesInfo":{"endUserId":"576834542256843538","serverReferenceCode":"3010211151505890884263535","language":"EN","accesschannel":"SMS"},"smsInfo":{"totalAmountCharged":"0","msgType":"SMSTEXT","productIdentifier":"3602","msgTransactionId":"3010211151505890884263535","servcieIdentifier":"PPU00026402668","shortcode":"19283","message":"EW 2"}}}';

include "db.php";
$txt = html_entity_decode($newtext);
$newtextjson = json_decode($txt);
$notify = $newtextjson->notify;

$accesInfo = $notify->accesInfo;
$smsInfo = $notify->smsInfo;

$endUserId = $accesInfo->endUserId;
$language = $accesInfo->language;
$accesschannel = $accesInfo->accesschannel;
$serverReferenceCode = $accesInfo->serverReferenceCode;

$servcieIdentifier = $smsInfo->servcieIdentifier;
$productIdentifier = $smsInfo->productIdentifier;
$msgTransactionId = $smsInfo->msgTransactionId;
$shortcode = $smsInfo->shortcode;
$message = $smsInfo->message;

$ftp = fopen("Log/Server_Hit_" . $datenew . ".txt", 'a+');
fwrite($ftp, $txt . "-" . $date . "\n");
fwrite($ftp, $endUserId . "-LN-" . $language . "-TXID-" . $msgTransactionId . "-SVCID" . $servcieIdentifier . "-" . $date . "\n");
fclose($ftp);

$selct = "select * from tbl_gp_keyword where service_id='$servcieIdentifier' AND service_type='PPU' limit 1";
$res = mysqli_query($con, $selct);
$row = mysqli_fetch_array($res, MYSQLI_ASSOC);
$skey = $row["service_key"];
$keyword = $row["keyword"];

$maincon = urlencode($message);
$msgType = $smsInfo->msgType;
$totalAmountCharged = $smsInfo->totalAmountCharged;


//$skey = "df428e7a306d48259e4ced7098cdf64c";
$rowcount = mysqli_num_rows($res);
if ($rowcount > 0) {
    $msisdn = $endUserId;
    $datekk = date("Y-m-d H:i:s");
    $content = "MT Content for key-" . $keyword;
    $content = urlencode($content);

    // Prepare XML data
    $xml = new SimpleXMLElement('<root/>');
    $xml->addChild('msisdn', $msisdn);
    $xml->addChild('text', $message);
    $xml->addChild('moid', $msgTransactionId);
    $xml->addChild('telcoid', '1');
    $xml->addChild('shortcode', $shortcode);
    $xml->addChild('datetime', $datekk);
    $xml->addChild('keyword', $keyword);

    $xmlString = $xml->asXML();

    $ftp2 = fopen("Log/mo_log_" . $datenew . ".txt", 'a+');
    fwrite($ftp2, $datekk . "-" . $xmlString . "-" . $servcieIdentifier . "\n");
    fclose($ftp2);

    postToMSMQ($xmlString);
}

function postToMSMQ($xmlData)
{
    try {
        $queuePath = ".\\Private$\\gp_messages";
        $queue = new COM("MSMQ.MSMQQueueInfo");
        $queue->PathName = $queuePath;
        $queueObj = $queue->Open(MQ_SEND_ACCESS, MQ_DENY_NONE);
        if (!$queueObj) {
            throw new Exception("Failed to open the queue.");
        }
        $msg = new COM("MSMQ.MSMQMessage");
        $msg->Label = "New SMS Message";
        $msg->Body = $xmlData;
        $msg->Send($queueObj);

        $queueObj->Close();
    } catch (Exception $e) {
        error_log("MSMQ Error: " . $e->getMessage());
    }
}

mysqli_free_result($res);
mysqli_close($con);
?>