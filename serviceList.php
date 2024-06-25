<?php
include_once("include/initialize.php");
date_default_timezone_set("Asia/Dhaka");
include_once("include/header.php");
require 'vendor/autoload.php';

$connection = mysqli_connect("localhost", "root", "", "smspanelNew");

if (!$connection) {
    die("Database connection failed: " . mysqli_connect_error());
}

$dataQuery = "SELECT * FROM service";
$dataResult = mysqli_query($connection, $dataQuery);

mysqli_close($connection);
?>
<style>
    .dropdown {
        position: relative;
        display: inline-block;
        margin-right: 30px;
        margin-top: 20px;
    }

    .dropdown-button {
        background-color: #35A29F;
        color: white;
        padding: 10px;
        border: none;
        cursor: pointer;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        background-color: #f9f9f9;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
        z-index: 1;
    }

    .dropdown-content a {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
    }

    .dropdown-content a:hover {
        background-color: #E2F6CA;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }

    .table {
        border-collapse: collapse;
        width: 100%;
        margin-bottom: 20px;
        background-color: #f8f9fa;
        box-shadow: rgba(50, 50, 93, 0.25) 0px 6px 12px -2px, rgba(0, 0, 0, 0.3) 0px 3px 7px -3px;
    }

    .table th,
    .table td {
        padding: 12px 15px;
        border-bottom: 1px solid #dee2e6;
        text-align: left;
    }

    .table th {
        background: linear-gradient(135deg, #2b5876 0%, #4e4376 100%);
        font-weight: 600;
        text-transform: uppercase;
        color: white;
    }

    .table tbody tr:nth-child(odd) {
        background-color: #e9ecef;
    }

    .table tbody tr:nth-child(even) {
        background-color: #f8f9fa;
    }

    .table tbody tr:hover {
        background-color: #dae0e5;
    }

    .panelDrop {
        margin-left: 25%;
        margin-top: 10px;
    }

    .arrow-icon {
        height: 20px;
        transition: transform 0.9s;
    }

    .dropdown:hover .arrow-icon {
        transform: rotate(180deg);
    }

    #serviceTypeSelect,
    #keywordsSelect {
        background-color: #F3FDE8;
        padding: 8px;
        border-radius: 3%;
    }

    #startDate {
        padding: 7px;
    }

    @media (max-width: 768px) {
        .panelDrop {
            margin-left: 0;
            text-align: center;
        }

        .dropdown {
            margin-bottom: 10px;
        }
    }

    @media (max-width: 576px) {

        .table th,
        .table td {
            padding: 8px 10px;
        }
    }
</style>

<div class="app-main__inner">
    <div class="row">
        <div class="col-md-12">
            <div class="main-card mb-3 card">
                <div class="card-header">Service List</div>
                <div class="panelDrop">
                    <div class="dropdown">
                        <input type="date" id="startDate" name="startDate">
                    </div>
                    <button id="filterButton" class="btn btn-primary button">Filter</button>
                </div>

                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Service Name</th>
                                    <th>Service Type</th>
                                    <th>Keywords</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php
                                if (mysqli_num_rows($dataResult) > 0) {
                                    while ($row = mysqli_fetch_assoc($dataResult)) {
                                        echo "<tr>";
                                        echo "<td>" . $row['service_name'] . "</td>";
                                        echo "<td>" . $row['service_type'] . "</td>";
                                        echo "<td>" . $row['keywords'] . "</td>";
                                        echo "</tr>";
                                    }
                                } else {
                                    echo "<tr><td colspan='3'>No data found</td></tr>";
                                }
                                ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        $('#filterButton').click(function() {
            var startDate = $('#startDate').val();
            // Add filtering logic here
        });
    });
</script>

<?php
include_once("include/footer.php");
?>