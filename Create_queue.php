<?php
// Define the constants
define('MQ_RECEIVE_ACCESS', 1);
define('MQ_DENY_NONE', 0);

function createMSMQQueue($queuePath) {
    try {
        // Initialize COM object for MSMQ
        $queueInfo = new COM("MSMQ.MSMQQueueInfo");

        // Set the queue path
        $queueInfo->PathName = $queuePath;

        // Check if the queue already exists
        try {
            $queue = $queueInfo->Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE);
            echo "Queue already exists.\n";
            $queue->Close();
        } catch (Exception $e) {
            // If the queue does not exist, create it
            $queueInfo->Label = "New Message Queue";
            $queueInfo->Create();
            echo "Queue created successfully.\n";
        }
    } catch (Exception $e) {
        echo "Error: " . $e->getMessage();
    }
}

// Define the queue path (local private queue)
$queuePath = ".\\Private$\\gp_messages";

// Call the function to create the queue
createMSMQQueue($queuePath);
?>
