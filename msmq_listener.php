<?php
define('MQ_RECEIVE_ACCESS', 1);
define('MQ_DENY_NONE', 0);

function peekMessage($queuePath)
{
    $queue = new COM("MSMQ.MSMQQueueInfo");
    $queue->PathName = $queuePath;
    $queue->Refresh();

    $queueObj = $queue->Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE);
    $msg = $queueObj->PeekCurrent();
    $queueObj->Close();

    return $msg;
}

$queuePath = ".\\private$\\messages";
$msg = peekMessage($queuePath);

$xml = simplexml_load_string($msg->Body);
$keyword = strtoupper((string)$xml->keyword);
$msisdn = (string)$xml->msisdn;

$valid_keywords = ["START CNS", "START FNS", "START BNS", "START LSU", "START MWP"];

if (in_array($keyword, $valid_keywords)) {
    $data = [
        'msisdn' => $msisdn,
        'keyword' => $keyword
    ];

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "http://103.228.39.37:88/smsPanel/insert_subscriber.php");
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    $response = curl_exec($ch);
    curl_close($ch);

    echo $response;
} else {
    echo "Keyword not valid.";
}
