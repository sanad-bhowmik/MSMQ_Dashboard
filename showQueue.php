<?php
include_once("fetch_queue.php");

$keywordFromQueue = fetchMessageFromQueue();

//var_dump($keywordFromQueue);
if (1 == 1) {
    $urlToHit = "http://103.228.39.37:88/smsPanel/sms.php?keyword=" . $keywordFromQueue;

    //$queryString = http_build_query(['keyword' => $keywordParam]);

    // $queryString = str_replace('%5B0%5D', '', $queryString);

    // $urlToHit .= '?' . $queryString;
    echo $urlToHit . "</br>";
    $response = file_get_contents($urlToHit);
    var_dump($response);

    $urlForMt = "http://103.228.39.37:88/smsPanel/mt.php?sms=" . urlencode($response);
    echo $urlForMt . "</br>";
    $response2 = file_get_contents($urlForMt);

    // $ch = curl_init();

    // curl_setopt($ch, CURLOPT_HEADER, 0);
    // curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    // curl_setopt($ch, CURLOPT_URL, $urlForMt);

    // $response2 = curl_exec($ch);
    // curl_close($ch);

    var_dump($response2);



    //  var_dump($response2);

} else {
    echo "<div class='container'>";
    echo "<h1>Message Queue Display</h1>";
    echo "<div id='response'>";
    echo "<h2>No keyword provided.</h2>";
    echo "</div>";
    echo "</div>";
}
?>
