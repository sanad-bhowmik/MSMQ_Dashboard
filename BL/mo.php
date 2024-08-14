<?php
$url = "http://103.228.39.37:88/smsPanel/sms.php";
$data = file_get_contents($url);

// Display the fetched data
echo "<div class='container'>";
echo "<h1>" . $data . "</h1>";
echo "<div id='response'>";
echo "</div>";
echo "</div>";
?>