<?php
$datetime = date('Y-m-d H:i:s');
$date = date('Y-m-d');
include_once("include/initialize.php");
date_default_timezone_set("Asia/Dhaka");
$msisdn = "not found";
$text = "not found";
$moid = "not found";
$telcoid = "not found";
$keyword = "not found";
$shortcode = "not found";
$ip = "";

if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ip = $_SERVER['HTTP_CLIENT_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
} else {
    $ip = $_SERVER['REMOTE_ADDR'];
}

if (isset($_REQUEST['msisdn'])) {
    $msisdn = $_REQUEST['msisdn'];
}
if (isset($_REQUEST['text'])) {
    $text = $_REQUEST['text'];
}
if (isset($_REQUEST['moid'])) {
    $moid = $_REQUEST['moid'];
}
if (isset($_REQUEST['telcoid'])) {
    $telcoid = $_REQUEST['telcoid'];
}
if (isset($_REQUEST['shortcode'])) {
    $shortcode = $_REQUEST['shortcode'];
}
if (isset($_REQUEST['keyword'])) {
    $keyword = $_REQUEST['keyword'];
}

$logdata = "msisdn: " . $msisdn;
$logdata .= " text: " . $text;
$logdata .= " moid: " . $moid;
$logdata .= " telcoid: " . $telcoid;
$logdata .= " shortcode: " . $shortcode;
$logdata .= " reqip: " . $ip;
$logdata .= " datetime: " . $datetime;
$logdata .= " keyword: " . $keyword;
$logdata .= "\n";

// $errorLogPath = "C:/htdocs/msmq/log/error/error_log_" . $date . ".txt";

// $filewrite = fopen("C:/htdocs/msmq/log/mo/mo_log_" . $date . ".txt", "a+");
// if ($filewrite) {
//     fwrite($filewrite, $logdata);
//     fclose($filewrite);
// } else {
//     $errorLogData = "Failed to open mo log file. Data: " . $logdata;
//     file_put_contents($errorLogPath, $errorLogData, FILE_APPEND | LOCK_EX);
// }

$xml = new SimpleXMLElement('<Message/>');
$xml->addChild('msisdn', $msisdn);
$xml->addChild('text', $text);
$xml->addChild('moid', $moid);
$xml->addChild('telcoid', $telcoid);
$xml->addChild('shortcode', $shortcode);
$xml->addChild('datetime', $datetime);
$xml->addChild('keyword', $keyword);

$xmlString = $xml->asXML();

define("MQ_SEND_ACCESS", 2);
define("MQ_DENY_NONE", 0);

try {
    $msgQueueInfo = new COM("MSMQ.MSMQQueueInfo");
    $msgQueueInfo->PathName = ".\\private$\\messages";

    $msgQueue = $msgQueueInfo->Open(MQ_SEND_ACCESS, MQ_DENY_NONE);
    if (!$msgQueue) {
        throw new Exception("Failed to open the queue.");
    }

    $msgOut = new COM("MSMQ.MSMQMessage");
    $msgOut->Body = $xmlString;
    $msgOut->Send($msgQueue);

    $msgQueue->Close();
    unset($msgOut);
    unset($msgQueue);
    unset($msgQueueInfo);

    echo "<div style='text-align: center; margin-top: 10px;'>Response Status Code: 200</div>";
} catch (Exception $e) {
    $errorLogData = "Error occurred: " . $e->getMessage() . " Data: " . $xmlString;
    file_put_contents($errorLogPath, $errorLogData, FILE_APPEND | LOCK_EX);

    echo "<div style='color: red; font-weight: bold; font-size: 24px; text-align: center; margin-top: 20%;'>An error occurred: " . $e->getMessage() . "</div>";
}

exit;
?>
<div class="app-main__inner">
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<script>
    toastr.options = {
        "positionClass": "toast-top-center",
        "closeButton": true,
        "progressBar": true,
    };
</script>
<?php
?>