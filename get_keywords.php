<?php
include_once("include/initialize.php");
$connection = mysqli_connect("localhost", "root", "", "smspanel");

if (!$connection) {
    die("Database connection failed: " . mysqli_connect_error());
}

if (isset($_POST['service_type'])) {
    $serviceType = $_POST['service_type'];
    $keywordsQuery = "SELECT DISTINCT keywords FROM service WHERE service_type = '$serviceType'";
    $keywordsResult = mysqli_query($connection, $keywordsQuery);

    if ($keywordsResult) {
        $options = '<option value="" disabled selected>Select a Keyword</option>';
        while ($row = mysqli_fetch_assoc($keywordsResult)) {
            $options .= '<option value="' . $row['keywords'] . '">' . $row['keywords'] . '</option>';
        }
        echo $options;
    } else {
        echo '<option value="" disabled>No keywords available</option>';
    }
}
?>
