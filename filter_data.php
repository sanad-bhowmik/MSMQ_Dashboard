<?php
include_once("include/initialize.php");
require 'vendor/autoload.php';

$connection = mysqli_connect("localhost", "root", "", "smspanel");

if (!$connection) {
    die("Database connection failed: " . mysqli_connect_error());
}

$serviceType = $_GET['service_type'];
$keyword = $_GET['keywords'];
$startDate = $_GET['start_date'];

$dataQuery = "SELECT * FROM sms WHERE service_type = '$serviceType' AND keywords = '$keyword'";
if (!empty($startDate)) {
    $dataQuery .= " AND DATE(datetime) = '$startDate'";
}
$dataResult = mysqli_query($connection, $dataQuery);

$data = [];
while ($row = mysqli_fetch_assoc($dataResult)) {
    $data[] = $row;
}

mysqli_close($connection);

header('Content-Type: application/json');
echo json_encode($data);
?>
