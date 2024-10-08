<?php
$dbhost = "localhost";
$dbusername = "root";
$dbpassword = "";
$dbname = "queue_db";

$conn = new mysqli($dbhost, $dbusername, $dbpassword, $dbname);

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => "Connection failed: " . $conn->connect_error]));
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $keyword = isset($_POST['keyword']) ? trim($_POST['keyword']) : '';
    $keywordCategory = isset($_POST['keywordCategory']) ? trim($_POST['keywordCategory']) : '';
    $keywordRemarks = isset($_POST['keywordRemarks']) ? trim($_POST['keywordRemarks']) : '';
    $telcoId = isset($_POST['telcoId']) ? intval($_POST['telcoId']) : 0;

    $urlResponse = 'http://103.228.39.37:88/smsPanel/sms.php';
    $keywordCharge = 2.78;
    $shortcode = '16658';
    $createdDate = date('Y-m-d H:i:s');
    $updatedDate = date('Y-m-d H:i:s');

    if (empty($keyword) || empty($keywordCategory)) {
        echo json_encode(['success' => false, 'message' => "Keyword and Keyword Category are required."]);
        exit;
    }

    $stmt = $conn->prepare("INSERT INTO tbl_keyword (keyword, keywordCategory, keywordRemark, keywordCharge, shortcode, urlResponse, createddate, updateddate) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssssss", $keyword, $keywordCategory, $keywordRemarks, $keywordCharge, $shortcode, $urlResponse, $createdDate, $updatedDate);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => "New keyword added successfully."]);
    } else {
        echo json_encode(['success' => false, 'message' => "Error: " . $stmt->error]);
    }

    $stmt->close();
}

$conn->close();
?>
