<?php
include_once("fetch_queue.php");

$keywordFromQueue = fetchMessageFromQueue();

//var_dump($keywordFromQueue);
if (1==1) {
    $urlToHit = "http://103.228.39.37:88/smsPanel/sms.php?keyword=".$keywordFromQueue;

    //$queryString = http_build_query(['keyword' => $keywordParam]);

    // $queryString = str_replace('%5B0%5D', '', $queryString);

   // $urlToHit .= '?' . $queryString;
    echo $urlToHit . "</br>";
    $response = file_get_contents($urlToHit);
    var_dump($response);

    $urlForMt = "http://103.228.39.37:88/smsPanel/mt.php?sms=".urlencode($response);
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


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Queue Display</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        #response {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
    </style>
</head>

<body>

</body>

</html>