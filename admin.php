<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "queue_db";
$today = date("Y-m-d");

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Count records in the sms table
$sql_sms = "SELECT COUNT(*) as smsCount FROM sms";
$result_sms = $conn->query($sql_sms);

$smsCount = 0;

if ($result_sms->num_rows > 0) {
    $row_sms = $result_sms->fetch_assoc();
    $smsCount = $row_sms["smsCount"];
}

// Count records in the service table
$sql_service = "SELECT COUNT(*) as serviceCount FROM service";
$result_service = $conn->query($sql_service);

$serviceCount = 0;

if ($result_service->num_rows > 0) {
    $row_service = $result_service->fetch_assoc();
    $serviceCount = $row_service["serviceCount"];
}

// Assuming you have data for the charts
$sms_data = [120, 150, 100, 200, 170, 240];  // Example data for SMS Trends
$users_data = [1500, 1600, 1550, 1580, 1590, 1570];  // Example data for System Statistics (Total Users)

$conn->close();
?>

<!--  Start content-->
<div class="app-main__inner">

    <div class="row">
        <!-- Existing Cards -->
        <div class="col-md-6 col-xl-4">
            <div class="card mb-3 widget-content bg-night-sky">
                <div class="widget-content-wrapper text-white">
                    <div class="widget-content-left">
                        <div class="widget-heading">Total SMS</div>
                        <div class="widget-subheading">Over All SMS</div>
                    </div>
                    <div class="widget-content-right">
                        <div class="widget-numbers text-white"><span><?= $smsCount ?></span></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-xl-4">
            <div class="card mb-3 widget-content bg-asteroid">
                <div class="widget-content-wrapper text-white">
                    <div class="widget-content-left">
                        <div class="widget-heading">Today <?= $today ?></div>
                        <div class="widget-subheading">Total Hits Today</div>
                    </div>
                    <div class="widget-content-right">
                        <div class="widget-numbers text-white"><span>0</span></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-xl-4">
            <div class="card mb-3 widget-content bg-grow-early">
                <div class="widget-content-wrapper text-white">
                    <div class="widget-content-left">
                        <div class="widget-heading">Services</div>
                        <div class="widget-subheading">Total Active Service</div>
                    </div>
                    <div class="widget-content-right">
                        <div class="widget-numbers text-white"><span><?= $serviceCount ?></span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row">
        <!-- SMS Trends Chart -->
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-header">
                    SMS Trends
                </div>
                <div class="card-body">
                    <canvas id="smsTrendsChart"></canvas>
                </div>
            </div>
        </div>

        <!-- System Statistics Chart -->
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-header">
                    System Statistics (Total Users)
                </div>
                <div class="card-body">
                    <canvas id="systemStatsChart"></canvas>
                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // SMS Trends Chart
    const smsTrendsCtx = document.getElementById('smsTrendsChart').getContext('2d');
    const smsTrendsChart = new Chart(smsTrendsCtx, {
        type: 'bar',
        data: {
            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            datasets: [{
                label: 'Total SMS',
                data: <?= json_encode($sms_data) ?>,
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    // System Statistics Chart
    const systemStatsCtx = document.getElementById('systemStatsChart').getContext('2d');
    const systemStatsChart = new Chart(systemStatsCtx, {
        type: 'line',
        data: {
            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            datasets: [{
                label: 'Total Users',
                data: <?= json_encode($users_data) ?>,
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>
<!--end content -->