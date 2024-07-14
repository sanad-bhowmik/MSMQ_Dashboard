<?php
set_time_limit(0);

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

$valid_keywords = ["START CNS", "START FNS", "START BNS", "START LSU", "START MWP"];

while (true) {
    $msg = peekMessage($queuePath);

    if ($msg) {
        $xml = simplexml_load_string($msg->Body);

        if ($xml !== false) {
            $keyword = strtoupper((string)$xml->keyword);
            $msisdn = (string)$xml->msisdn;

            // Sanitize keyword to remove unwanted characters
            $keyword = preg_replace('/[^A-Z ]/', '', $keyword);
            $keyword_parts = preg_split('/\s+/', $keyword);
            $sanitized_keyword = implode(' ', array_filter($keyword_parts, function($part) {
                return preg_match('/^[A-Z]+$/', $part);
            }));

            if (in_array($sanitized_keyword, $valid_keywords)) {
                $data = [
                    'msisdn' => $msisdn,
                    'keyword' => $sanitized_keyword
                ];
                $datenn = date('Y-m-d H:i:s');
                $today = date("Y-m-d");
                $url = "http://103.228.39.37:88/smsPanel/insert_subscriber.php";
                $ftp222 = fopen("C:\\mts\\htdocs\\msmq\\log\\Subscriber_HIT_" . $today . ".txt", 'a+');
                fwrite($ftp222, $url . "?msisdn=" . $msisdn . "&keyword=" . $sanitized_keyword . "\n");
                fclose($ftp222);

                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $url);
                curl_setopt($ch, CURLOPT_POST, 1);
                curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

                $response = curl_exec($ch);
                curl_close($ch);

                echo $response . "\n";
            } else {
                echo "Keyword not valid.\n";
            }
        } else {
            echo "Error parsing XML.\n";
        }
    } else {
        echo "No messages in the queue.\n";
    }

    sleep(1);
}
