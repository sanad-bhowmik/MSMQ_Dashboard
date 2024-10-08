<?php
include_once("include/initialize.php");
date_default_timezone_set("Asia/Dhaka");
include_once("include/header.php");
require 'vendor/autoload.php';

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "queue_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT DISTINCT shortcode FROM tbl_keyword";
$result = $conn->query($sql);
$shortcodes = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $shortcodes[] = $row["shortcode"];
    }
}

$search_query = "";
if (isset($_GET['search'])) {
    $keyword_name = isset($_GET['keyword_name']) ? $conn->real_escape_string($_GET['keyword_name']) : '';
    $shortcode = isset($_GET['shortcode']) ? $conn->real_escape_string($_GET['shortcode']) : '';

    $search_query = " WHERE 1=1 ";

    if (!empty($keyword_name)) {
        $search_query .= " AND keyword LIKE '%$keyword_name%'";
    }

    if (!empty($shortcode)) {
        $search_query .= " AND shortcode = '$shortcode'";
    }
}

$sql = "SELECT keywordID, keyword, shortcode, urlResponse FROM tbl_keyword" . $search_query . " ORDER BY updateddate DESC";
$result = $conn->query($sql);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KeyWord</title>
    <link rel="stylesheet" href="../style/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
</head>

<body>
    <form class="form-style-9" method="GET" action="">
        <h5 style="margin-top: 0;text-align: center;font-family: fangsong;">Add Keyword</h5>
        <ul>
            <li>
                <select name="account" class="field-style">
                    <option value="" selected disabled>Account</option>
                    <option value="SC001" <?php if (isset($_GET['account']) && $_GET['account'] == 'SC001') echo 'selected'; ?>>SC001</option>
                    <option value="SC002" <?php if (isset($_GET['account']) && $_GET['account'] == 'SC002') echo 'selected'; ?>>SC002</option>
                    <option value="SC003" <?php if (isset($_GET['account']) && $_GET['account'] == 'SC003') echo 'selected'; ?>>SC003</option>
                </select>

                <input type="text" name="rec_id" class="field-style" placeholder="Rec ID"
                    value="<?php echo isset($_GET['rec_id']) ? htmlspecialchars($_GET['rec_id']) : ''; ?>" />

                <input type="text" name="keyword_name" class="field-style" placeholder="Keyword Name"
                    value="<?php echo isset($_GET['keyword_name']) ? htmlspecialchars($_GET['keyword_name']) : ''; ?>" />
            </li>

            <li>
                <select name="sms_type" class="field-style">
                    <option value="" selected disabled>SMS Type</option>
                </select>

                <select name="shortcode" class="field-style">
                    <option value="" selected disabled>Shortcode</option>
                    <?php
                    foreach ($shortcodes as $shortcode) {
                        echo '<option value="' . htmlspecialchars($shortcode) . '"';
                        if (isset($_GET['shortcode']) && $_GET['shortcode'] == $shortcode) {
                            echo ' selected';
                        }
                        echo '>' . htmlspecialchars($shortcode) . '</option>';
                    }
                    ?>
                </select>

                <input type="url" name="app_url" class="field-style" placeholder="App URL"
                    value="<?php echo isset($_GET['app_url']) ? htmlspecialchars($_GET['app_url']) : ''; ?>" />

                <textarea name="sms_text" class="field-style" placeholder="SMS Text" style="height: 36px;"><?php echo isset($_GET['sms_text']) ? htmlspecialchars($_GET['sms_text']) : ''; ?></textarea>

                <input type="submit" name="search" value="Search" style="margin-right: 3px;">
                <input type="button" class="clear-button" value="Clear" onclick="clearForm()">
            </li>
        </ul>
    </form>

    <div class="table-wrapper">
        <table class="fl-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Keyword</th>
                    <th>Shortcode</th>
                    <th>App URL</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php
                if ($result->num_rows > 0) {
                    $index = 1;
                    while ($row = $result->fetch_assoc()) {
                        echo "<tr>";
                        echo "<td>" . $index . "</td>";
                        echo "<td>" . htmlspecialchars($row["keyword"]) . "</td>";
                        echo "<td>" . htmlspecialchars($row["shortcode"]) . "</td>";
                        echo "<td>" . htmlspecialchars($row["urlResponse"]) . "</td>";
                        echo "<td>
                            <button class='btn-31' onclick='openModal(\"" . htmlspecialchars($row["keyword"]) . "\", \"" . htmlspecialchars($row["shortcode"]) . "\", \"" . htmlspecialchars($row["urlResponse"]) . "\", " . $row["keywordID"] . ")'>
                                <span class='text-container'>
                                    <span class='text'>Edit</span>
                                </span>
                            </button>
                        </td>";
                        echo "</tr>";
                        $index++;
                    }
                } else {
                    echo "<tr><td colspan='5'>No data available</td></tr>";
                }
                ?>
            </tbody>
        </table>
    </div>

    <div id="myModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <form id="modal-form">
                <label for="modal-keyword">Keyword:</label>
                <input type="text" id="modal-keyword" name="keyword" required />

                <label for="modal-shortcode">Shortcode:</label>
                <input type="text" id="modal-shortcode" name="shortcode" required />

                <label for="modal-urlResponse">App URL:</label>
                <input type="text" id="modal-urlResponse" name="urlResponse" readonly />

                <input type="hidden" id="modal-keywordID" name="keywordID" />

                <button type="submit" class="update-button">Update</button>
            </form>
        </div>
    </div>

    <script>
        function openModal(keyword, shortcode, urlResponse, keywordID) {
            document.getElementById("modal-keyword").value = keyword;
            document.getElementById("modal-shortcode").value = shortcode;
            document.getElementById("modal-urlResponse").value = urlResponse;
            document.getElementById("modal-keywordID").value = keywordID;

            document.getElementById("myModal").style.display = "block";
        }

        function closeModal() {
            document.getElementById("myModal").style.display = "none";
        }

        $(document).ready(function() {
            $("#modal-form").on("submit", function(event) {
                event.preventDefault();

                var keyword = $("#modal-keyword").val();
                var shortcode = $("#modal-shortcode").val();
                var urlResponse = $("#modal-urlResponse").val();
                var keywordID = $("#modal-keywordID").val();

                // Check if keywordID is set
                if (!keywordID) {
                    toastr.error("Invalid keyword ID.");
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: "update_keyword.php",
                    data: {
                        keyword: keyword,
                        shortcode: shortcode,
                        urlResponse: urlResponse,
                        keywordID: keywordID
                    },
                    success: function(response) {
                        response = JSON.parse(response);
                        if (response.status === "success") {
                            toastr.success("Keyword updated successfully!");
                            alert("Keyword updated successfully!");
                            location.reload();
                        } else {
                            toastr.error(response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        toastr.error("Error updating keyword.");
                    }
                });
            });
        });

        function clearForm() {
            document.querySelector('.form-style-9').reset();
            window.location.href = window.location.pathname;
        }
    </script>

</body>

</html>


<style>
    .update-button {
        background-color: #a649da;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        cursor: pointer;
        margin-top: 10px;
        transition: background-color 0.3s;
    }

    .update-button:hover {
        background-color: #8c3c9b;
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgb(0, 0, 0);
        background-color: rgba(0, 0, 0, 0.4);
    }

    .modal-content {
        background-color: #fefefe;
        margin: 10% auto;
        padding: 20px;
        border: 1px solid #888;
        width: 35%;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    .close {
        color: #2d2b2b;
        float: right;
        font-size: 28px;
        font-weight: bold;
        margin-left: 96%;
    }

    .close:hover,
    .close:focus {
        color: black;
        text-decoration: none;
        cursor: pointer;
    }

    .modal-content input[type="text"] {
        width: 100%;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 16px;
        transition: border-color 0.3s;
    }

    .modal-content input[type="text"]:focus {
        border-color: #a649da;
        outline: none;
        box-shadow: 0 0 5px rgba(166, 73, 218, 0.5);
    }

    .btn-31 {
        background-color: #007BFF;
        border: none;
        color: white;
        padding: 7px 17px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 10px;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .btn-31:hover {
        background-color: #0056b3;
        /* Darker shade for hover effect */
    }

    .text-container {
        display: inline-block;
    }

    .text {
        font-weight: bold;
    }

    .form-style-9 {
        max-width: 98%;
        padding: 20px;
        background-color: white;
        box-shadow: rgba(149, 157, 165, 0.2) 0px 8px 24px;
        border: 1px solid #dbd4d4;
        border-radius: 10px;
        height: 33%;
        /* Adjust height to auto to fit content */
        margin-top: 20px;
        margin-left: 1%;
    }

    .form-style-9 ul {
        padding: 0;
        margin: 0;
        list-style: none;
    }

    .form-style-9 ul li {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
        min-height: 35px;
    }

    .form-style-9 ul li .field-style {
        box-sizing: border-box;
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        padding: 8px;
        outline: none;
        border: 1px solid #B0CFE0;
        -webkit-transition: all 0.30s ease-in-out;
        -moz-transition: all 0.30s ease-in-out;
        -ms-transition: all 0.30s ease-in-out;
        -o-transition: all 0.30s ease-in-out;
        flex: 1;
        margin-right: 10px;
        /* Add margin to right for spacing */
    }

    .form-style-9 ul li .field-style:last-child {
        margin-right: 0;
        /* Remove margin from the last child */
    }

    .form-style-9 ul li .field-style:focus {
        box-shadow: 0 0 5px #B0CFE0;
        border: 1px solid #B0CFE0;
    }

    .form-style-9 ul li .field-full {
        width: 100%;
    }

    .form-style-9 ul li textarea {
        width: 100%;
        height: 100px;
    }

    .form-style-9 ul li input[type="button"],
    .form-style-9 ul li input[type="submit"] {
        -moz-box-shadow: inset 0px 1px 0px 0px #3985B1;
        -webkit-box-shadow: inset 0px 1px 0px 0px #3985B1;
        box-shadow: inset 0px 1px 0px 0px #3985B1;
        background-color: #216288;
        border: 1px solid #17445E;
        display: inline-block;
        cursor: pointer;
        color: #FFFFFF;
        padding: 8px 18px;
        text-decoration: none;
        font: 12px Arial, Helvetica, sans-serif;
    }

    .form-style-9 ul li input[type="button"]:hover,
    .form-style-9 ul li input[type="submit"]:hover {
        background: linear-gradient(to bottom, #2D77A2 5%, #337DA8 100%);
        background-color: #28739E;
    }


    .table-wrapper {
        margin: 35px 74px 70px 12px;

    }

    .fl-table {
        border-radius: 5px;
        font-size: 12px;
        font-weight: normal;
        border: none;
        border-collapse: collapse;
        width: 107%;
        max-width: 109%;
        white-space: nowrap;
        background-color: white;
    }

    .fl-table td,
    .fl-table th {
        text-align: center;
        padding: 8px;
    }

    .fl-table td {
        border-right: 1px solid #f8f8f8;
        font-size: 12px;
    }

    .fl-table thead th {
        color: #ffffff;
        background: #4FC3A1;
    }


    .fl-table thead th:nth-child(odd) {
        color: #ffffff;
        background: #5eccaf;
    }

    .fl-table tr:nth-child(even) {
        background: #F8F8F8;
    }

    /* Responsive */

    @media (max-width: 767px) {
        .fl-table {
            display: block;
            width: 100%;
        }

        .table-wrapper:before {
            content: "Scroll horizontally >";
            display: block;
            text-align: right;
            font-size: 11px;
            color: white;
            padding: 0 0 10px;
        }

        .fl-table thead,
        .fl-table tbody,
        .fl-table thead th {
            display: block;
        }

        .fl-table thead th:last-child {
            border-bottom: none;
        }

        .fl-table thead {
            float: left;
        }

        .fl-table tbody {
            width: auto;
            position: relative;
            overflow-x: auto;
        }

        .fl-table td,
        .fl-table th {
            padding: 20px .625em .625em .625em;
            height: 60px;
            vertical-align: middle;
            box-sizing: border-box;
            overflow-x: hidden;
            overflow-y: auto;
            width: 120px;
            font-size: 13px;
            text-overflow: ellipsis;
        }

        .fl-table thead th {
            text-align: left;
            border-bottom: 1px solid #f7f7f9;
        }

        .fl-table tbody tr {
            display: table-cell;
        }

        .fl-table tbody tr:nth-child(odd) {
            background: none;
        }

        .fl-table tr:nth-child(even) {
            background: transparent;
        }

        .fl-table tr td:nth-child(odd) {
            background: #F8F8F8;
            border-right: 1px solid #E6E4E4;
        }

        .fl-table tr td:nth-child(even) {
            border-right: 1px solid #E6E4E4;
        }

        .fl-table tbody td {
            display: block;
            text-align: center;
        }
    }
</style>