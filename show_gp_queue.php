<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "queue_db";

// Create a new PDO instance for database connection
try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Database connection failed: " . $e->getMessage();
    exit;
}

function getMessagesFromQueue($queuePath) {
    $messages = [];
    try {
        // Create a COM object for MSMQQueueInfo
        $queueInfo = new COM("MSMQ.MSMQQueueInfo");
        $queueInfo->PathName = $queuePath; // Use PathName to specify the queue

        // Open the queue for receiving messages
        $queue = $queueInfo->Open(1, 0); // 1 = MQ_RECEIVE, 0 = MQ_DENY_NONE

        // Receive messages from the queue
        while (true) {
            $message = $queue->Receive(1000); // Timeout of 1000 ms
            if ($message === null) break; // No more messages to read
            $messages[] = $message->Body;
        }

        // Close the queue
        $queue->Close();
    } catch (Exception $e) {
        echo "Error: " . $e->getMessage();
    }
    return $messages;
}

function processMessage($xmlContent) {
    global $pdo;

    $xml = simplexml_load_string($xmlContent);
    $keyword = (string) $xml->keyword;

    $stmt = $pdo->prepare("SELECT urlResponse FROM tbl_keyword WHERE keyword = ?");
    $stmt->execute([$keyword]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($result) {
        $url = $result['urlResponse'];
        $response = file_get_contents($url . '?keyword=' . urlencode($keyword));
        if ($response !== false && strpos($http_response_header[0], '200') !== false) {
            echo "Request successful";
        } else {
            echo "Request failed";
        }
    } else {
        echo "Keyword not found in database";
    }
}

// Use the predefined path to the queue
$queuePath = ".\\private$\\gp_messages"; // Adjust path according to your queue configuration
$messages = getMessagesFromQueue($queuePath);

foreach ($messages as $message) {
    processMessage($message);
}
?>
