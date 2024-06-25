<?php
include_once("include/initialize.php");
date_default_timezone_set("Asia/Dhaka");
include_once("include/header.php");

if (isset($_POST['submit'])) {
    $service_name = $_POST['service_name'];
    $service_type = $_POST['service_type'];
    $keywords = $_POST['keywords'];

    $connection = mysqli_connect("localhost", "root", "", "smspanelNew");

    if (!$connection) {
        die("Database connection failed: " . mysqli_connect_error());
    }

    $existingKeywordsQuery = "SELECT COUNT(*) AS keyword_count FROM service WHERE keywords = '$keywords'";
    $existingKeywordsResult = mysqli_query($connection, $existingKeywordsQuery);
    $existingKeywordsData = mysqli_fetch_assoc($existingKeywordsResult);
    $keywordCount = $existingKeywordsData['keyword_count'];

    if ($keywordCount > 0) {
        echo '<script>toastr.error("Keywords already exist.");</script>';
    } else {
        $query = "INSERT INTO service (service_name, service_type, keywords) VALUES ('$service_name', '$service_type', '$keywords')";
        
        if (mysqli_query($connection, $query)) {
            echo '<script>toastr.success("Service added successfully.");</script>';
        } else {
            echo "Error: " . $query . "<br>" . mysqli_error($connection);
        }
    }

    mysqli_close($connection);
}
?>
<style>
   #uploadForm {
       box-shadow: rgba(0, 0, 0, 0.24) 0px 3px 8px;
       background: #F1F0E8;
       padding: 10px;
   }
   
   #uploadForm label {
       margin: 2px;
       font-size: 1em;
       font-weight: bold;
   }
   
   .demoInputBox {
       padding: 5px;
       border: #F0F0F0 1px solid;
       border-radius: 4px;
       background-color: #FFF;
   }
   
   #progress-bar {
       background-color: #12CC1A;
       height: 20px;
       color: #FFFFFF;
       width: 0%;
       -webkit-transition: width .3s;
       -moz-transition: width .3s;
       transition: width .3s;
   }
   
   .btnSubmit {
       background-color: #09f;
       border: 0;
       padding: 10px 40px;
       color: #FFF;
       border: #F0F0F0 1px solid;
       border-radius: 4px;
   }
   
   #progress-div {
       border: #0FA015 1px solid;
       padding: 5px 0px;
       margin: 30px 0px;
       border-radius: 4px;
       text-align: center;
   }
   
   #targetLayer {
       width: 100%;
       text-align: center;
   }
   
   .text {
       font-weight: bold;
   
   }
   
   .form-group {
       font-size: 15px;
   }
</style>

<!-- Main content -->
<div class="app-main__inner">
    <div class="row">
        <div class="col-md-12">
            <div class="main-card mb-3 card">
                <div class="card-header">Add Service's</div>
                <div class="card-body">

                    <form id="uploadForm" action="" method="post">

                        <div class="position-relative column  form-group  p-t-10">
                            <div class="col-sm-4" style="margin-bottom: 2%">
                                <p class="text">Service Name</p>
                                <input type="text" required="true" name="service_name" class="form-control"
                                    id="Service_name" placeholder="Service Name" style="font-size: 13px;">
                            </div>

                            <div class="col-sm-4" style="margin-bottom: 2%">
                                <label class="text" for="service_type">Service Type</label>
                                <select required="true" name="service_type" class="form-control"
                                    style="font-size: 13px;">
                                    <option value="" disabled selected>Select a ServiceType</option>
                                    <option value="PPU">PPU</option>
                                    <option value="Subscriptions">Subscriptions</option>
                                </select>
                            </div>

                            <div class="col-sm-4">
                                <p class="text">Keywords</p>
                                <input type="text" required="true" name="keywords" class="form-control"
                                    placeholder="Keywords" style="font-size: 13px;">
                            </div>

                        </div>
                        <hr>
                        <div class="position-relative row form-group p-t-10 ">
                            <div class="col-sm-4 ">
                                <button id="submit" type="submit" name="submit"
                                    class="btn btn-secondary">Add</button>
                            </div>
                        </div>

                    </form>
                </div>
                <div id="loader-icon" style="display:none;"><img src="LoaderIcon.gif" /></div>

            </div>
        </div>
    </div>
    <!--end row -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<script>
// Initialize toastr options
toastr.options = {
    "positionClass": "toast-top-center",
    "closeButton": true,
    "progressBar": true,
};
</script>

<?php
include_once("include/footer.php");
?>