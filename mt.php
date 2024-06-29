<?php
$date = date('Y-m-d');
if (isset($_REQUEST['sms'])) {

  $sms = $_REQUEST['sms'];

  $filewrite = fopen("C:/xampp/htdocs/MSMQ_Queue/logs/mo/mo_log_" . $date . ".txt", "a+");
  if ($filewrite) {
    fwrite($filewrite, $sms);
    fclose($filewrite);
    echo 200;
  } else {
    // $errorLogData = "Failed to open mo log file. Data: " . $logdata;
    // file_put_contents($errorLogPath, $errorLogData, FILE_APPEND | LOCK_EX);
  }
} else {

  echo 400;
}
?>