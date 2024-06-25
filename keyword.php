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

$sql = "SELECT keywordID, keyword, keywordCharge, shortcode, urlResponse, keywordRemark FROM tbl_keyword";
$result = $conn->query($sql);

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KeyWord</title>
    <link rel="stylesheet" href="../style/style.css">

</head>

<style>
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

<body>
    <form class="form-style-9" method="GET" action="">
        <h5 style="margin-top: 0;text-align: center;font-family: fangsong;">Add Keyword</h5>
        <ul>
            <li>
                <select name="field1" class="field-style">
                    <option value="" selected disabled>Account</option>
                    <option value="SC001">SC001</option>
                    <option value="SC002">SC002</option>
                    <option value="SC003">SC003</option>
                </select>

                <input type="text" name="field3" class="field-style" placeholder="Rec ID" value="" />

                <input type="text" name="field3" class="field-style" placeholder="Keyword Name" value="" />

                <select name="field2" class="field-style">
                    <option value="" selected disabled>Charge</option>
                    <?php
                    // Output options for keywordCharge
                    foreach ($charges as $charge) {
                        echo '<option value="' . htmlspecialchars($charge) . '">' . htmlspecialchars($charge) . 'tk</option>';
                    }
                    ?>
                </select>

            </li>

            <li>
                <select name="field2" class="field-style">
                    <option value="" selected disabled>SMS Type</option>
                </select>

                <select name="shortcode" class="field-style">
                    <option value="" selected disabled>Shortcode</option>
                    <?php
                    // Output options for shortcode
                    foreach ($shortcodes as $shortcode) {
                        echo '<option value="' . htmlspecialchars($shortcode) . '">' . htmlspecialchars($shortcode) . '</option>';
                    }
                    ?>
                </select>

                <input type="url" name="field3" class="field-style" placeholder="App URL" value="" />

                <textarea type="text" name="field3" class="field-style" placeholder="SMS Text" value="" style="height: 36px;"></textarea>

                <input type="submit" name="search" value="Search" style="margin-right: 3px;">

            </li>
        </ul>
    </form>

    <div class="table-wrapper">
        <table class="fl-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Keyword</th>
                    <th>Charge</th>
                    <th>Shortcode</th>
                    <th>App URL</th>
                    <th>Remark</th>
                </tr>
            </thead>
            <tbody>
                <?php
                if ($result->num_rows > 0) {
                    // Output data of each row
                    $index = 1;
                    while ($row = $result->fetch_assoc()) {
                        echo "<tr>";
                        echo "<td>" . $index . "</td>";
                        echo "<td>" . $row["keyword"] . "</td>";
                        echo "<td>" . $row["keywordCharge"] . "</td>";
                        echo "<td>" . $row["shortcode"] . "</td>";
                        echo "<td>" . $row["urlResponse"] . "</td>";
                        echo "<td>" . $row["keywordRemark"] . "</td>";
                        echo "</tr>";
                        $index++;
                    }
                } else {
                    echo "<tr><td colspan='6'>No data available</td></tr>";
                }
                ?>
            </tbody>
        </table>
    </div>

</body>

</html>

<script>
    function clearForm() {
        // Select all form inputs
        var formInputs = document.querySelectorAll('.form-style-9 input, .form-style-9 select');

        formInputs.forEach(function(input) {
            switch (input.type) {
                case 'text':
                case 'tel':
                case 'date':
                    input.value = '';
                    break;
                case 'select-one':
                    input.selectedIndex = 0;
                    break;
                default:
                    break;
            }
        });
    }
</script>