<?php
       $servername = "localhost";
       $username = "root";
       $password = "";
       $dbname = "smspanelNew";
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
       
       $conn->close();
?>
<!--  Start content-->
<div class="app-main__inner">

    <div class="row">
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
                        <div class="widget-heading">Today <?=$today?></div>
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
                        <div class="widget-heading">Sevices</div>
                        <div class="widget-subheading">Total Active Service</div>
                    </div>
                    <div class="widget-content-right">
                        <div class="widget-numbers text-white"><span><?= $serviceCount ?></span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12 col-lg-12">
            <div class="mb-3 card">
                <div class="card-header-tab card-header-tab-animation card-header">
                    <div class="card-header-title">
                        <i class="header-icon lnr-apartment icon-gradient bg-love-kiss"> </i>
                        <!-- Hit Report -->
                    </div>

                </div>
                <div class="card-body">


                </div>
            </div>
        </div>
    </div>
    <!--end row -->



</div>



<!--end content -->