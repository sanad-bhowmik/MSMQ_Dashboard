<?php
include_once("fetch_queue.php");

$keywordFromQueue = $keywordQ;

$queueDbServername = "localhost";
$queueDbUsername = "root";
$queueDbPassword = "";
$queueDbName = "queue_db";

$queueConn = new mysqli($queueDbServername, $queueDbUsername, $queueDbPassword, $queueDbName);

if ($queueConn->connect_error) {
    die("Connection failed: " . $queueConn->connect_error);
}

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

if (1 == 1) {
    $urlToHit = $urlFromDb . "?keyword=" . $keywordFromQueue;

    echo $urlToHit . "</br>";
    $response = file_get_contents($urlToHit);
    var_dump($response);

    $urlForMt = "http://103.228.39.37:88/smsPanel/mt.php?sms=" . urlencode($response);
    echo $urlForMt . "</br>";
    $response2 = file_get_contents($urlForMt);

    var_dump($response2);
} else {
    echo "<div class='container'>";
    echo "<h1>Message Queue Display</h1>";
    echo "<div id='response'>";
    echo "<h2>No keyword provided.</h2>";
    echo "</div>";
    echo "</div>";
}
