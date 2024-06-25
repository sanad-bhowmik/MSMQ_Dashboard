<?php
include 'fetch_queue.php';

// Fetch the message from the queue
$keywordFromQueue = fetchMessageFromQueue();

// Get the keyword parameter from the URL
$keywordParam = isset($_GET['keyword']) ? $_GET['keyword'] : '';

// If a keyword was retrieved from the queue, use it instead of the URL parameter
if ($keywordFromQueue) {
    $keywordParam = $keywordFromQueue;
}

if ($keywordParam) {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "queue_db";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $stmt = $conn->prepare("SELECT urlResponse FROM tbl_keyword WHERE keyword = ?");
    $stmt->bind_param("s", $keywordParam);
    $stmt->execute();
    $stmt->bind_result($urlResponse);
    $stmt->fetch();
    $stmt->close();
    $conn->close();

    if ($urlResponse) {
        // Send an HTTP request to the URL without displaying the response
        file_get_contents($urlResponse);

        // Display a success message
        echo "<div id='response'>";
        echo "<h2>URL hit successfully.</h2>";
        echo "</div>";
    } else {
        echo "<div id='response'>";
        echo "<h2>No matching keyword found in the database.</h2>";
        echo "</div>";
    }
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

        #message,
        #response {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
        }

        ul {
            list-style-type: none;
            padding: 0;
        }

        ul li {
            margin-bottom: 10px;
        }

        ul li strong {
            font-weight: bold;
            margin-right: 5px;
        }

        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>

<body>
    
</body>

</html>