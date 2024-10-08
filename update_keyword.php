<?php
include_once("include/initialize.php");
date_default_timezone_set("Asia/Dhaka");
require 'vendor/autoload.php';

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "queue_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $keyword = isset($_POST['keyword']) ? $conn->real_escape_string($_POST['keyword']) : '';
    $shortcode = isset($_POST['shortcode']) ? $conn->real_escape_string($_POST['shortcode']) : '';
    $urlResponse = isset($_POST['urlResponse']) ? $conn->real_escape_string($_POST['urlResponse']) : '';
    $keywordID = isset($_POST['keywordID']) ? (int)$_POST['keywordID'] : 0;

    if ($keywordID > 0) {
        $sql = "UPDATE tbl_keyword SET keyword='$keyword', shortcode='$shortcode', urlResponse='$urlResponse', updateddate=NOW() WHERE keywordID=$keywordID";

        if ($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Database update error: " . $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid keyword ID."]);
    }
}

$conn->close();
?>
