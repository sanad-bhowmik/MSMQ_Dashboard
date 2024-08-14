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

function getMessagesFromQueue($queueName) {
    $queue = new COM("MSMQ.MSMQQueueInfo");
    $queue->Name = $queueName;
    $queue = $queue->Create();

    $messages = [];
    while (true) {
        $message = $queue->GetMessage();
        if (!$message) break;
        $messages[] = $message->Body;
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
    }
}

$queueName = 'gp_messages';
$messages = getMessagesFromQueue($queueName);

foreach ($messages as $message) {
    processMessage($message);
}
?>
