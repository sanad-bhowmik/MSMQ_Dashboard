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

$where_conditions = array();

if (isset($_GET['field1']) && $_GET['field1'] != '') {
    $short_code = $conn->real_escape_string($_GET['field1']);
    $where_conditions[] = "recvKeyword = '$short_code'";
}

if (isset($_GET['field2']) && $_GET['field2'] != '') {
    $keywordID = $conn->real_escape_string($_GET['field2']);
    $where_conditions[] = "recvKeyword = '$keywordID'";
}

if (isset($_GET['field3']) && $_GET['field3'] != '') {
    $sms_text = $conn->real_escape_string($_GET['field3']);
    $where_conditions[] = "recvMsg LIKE '%$sms_text%'";
}

if (isset($_GET['field4']) && $_GET['field4'] != '') {
    $msisdn = $conn->real_escape_string($_GET['field4']);
    $where_conditions[] = "recvPhone = '$msisdn'";
}

if (isset($_GET['from_date']) && $_GET['from_date'] != '' && isset($_GET['to_date']) && $_GET['to_date'] != '') {
    $from_date = $conn->real_escape_string($_GET['from_date']);
    $to_date = $conn->real_escape_string($_GET['to_date']);
    $where_conditions[] = "recvDate BETWEEN '$from_date' AND '$to_date'";
} elseif (isset($_GET['from_date']) && $_GET['from_date'] != '') {
    $from_date = $conn->real_escape_string($_GET['from_date']);
    $where_conditions[] = "recvDate >= '$from_date'";
} elseif (isset($_GET['to_date']) && $_GET['to_date'] != '') {
    $to_date = $conn->real_escape_string($_GET['to_date']);
    $where_conditions[] = "recvDate <= '$to_date'";
}

$sql_keywords = "SELECT keywordID, keyword FROM tbl_keyword";
$result_keywords = $conn->query($sql_keywords);

$options = array();

if ($result_keywords->num_rows > 0) {
    while ($row = $result_keywords->fetch_assoc()) {
        $options[$row['keywordID']] = $row['keyword'];
    }
}

$where_clause = '';
if (!empty($where_conditions)) {
    $where_clause = " WHERE " . implode(" AND ", $where_conditions);
}

// Pagination logic
$records_per_page = 13;
$page = isset($_GET['page']) ? $_GET['page'] : 1;
$start_from = ($page - 1) * $records_per_page;

$sql_count = "SELECT COUNT(*) AS total_records FROM tbl_inbox" . $where_clause;
$result_count = $conn->query($sql_count);
$row_count = $result_count->fetch_assoc();
$total_records = $row_count['total_records'];
$total_pages = ceil($total_records / $records_per_page);

$sql = "SELECT recvPhone, recvMsg, recvDate, recvKeyword, recvTelcoID 
        FROM tbl_inbox" . $where_clause . " 
        ORDER BY recvID DESC LIMIT $start_from, $records_per_page";
$result = $conn->query($sql);

// Fetch keyword remarks
$sql_keyword_remarks = "SELECT keyword, keywordRemark FROM tbl_keyword";
$result_keyword_remarks = $conn->query($sql_keyword_remarks);
$keyword_remarks = array();
if ($result_keyword_remarks->num_rows > 0) {
    while ($row = $result_keyword_remarks->fetch_assoc()) {
        $keyword_remarks[$row['keyword']] = $row['keywordRemark'];
    }
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inbox</title>
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

    .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: -50px;
        margin-bottom: 33px;
    }

    .pagination a {
        color: #1c6aae;
        padding: 8px 12px;
        margin: 0 5px;
        text-decoration: none;
        background-color: #f1f1f1;
        border: 1px solid #1c6aae;
        border-radius: 23%;
        transition: background-color 0.3s, color 0.3s;
    }

    .pagination a.active {
        background-color: #1c6aae;
        color: white;
        border: 1px solid #1c6aae;
    }

    .pagination a:hover:not(.active) {
        background-color: #ddd;
    }

    .pagination a.disabled {
        pointer-events: none;
        cursor: default;
        color: #bbb;
        border-color: #bbb;
    }
</style>

<body>
    <form class="form-style-9" method="GET" action="">
        <h3 style="margin-top: 0;text-align: center;font-family: serif;">Inbound Traffic Log</h3>
        <ul>
            <li>
                <select name="field1" class="field-style">
                    <option value="" selected disabled>Short Code</option>
                    <option value="SC001">SC001</option>
                    <option value="SC002">SC002</option>
                    <option value="SC003">SC003</option>
                </select>
                <select name="field2" class="field-style">
                    <option value="" selected disabled>Keyword</option>
                    <?php
                    // Loop through $options to generate <option> tags
                    foreach ($options as $key => $opt) {
                        echo '<option value="' . htmlspecialchars($key) . '">' . htmlspecialchars($opt) . '</option>';
                    }
                    ?>
                </select>
                <input type="text" name="field3" class="field-style" placeholder="SMS Text" value="<?php echo isset($_GET['field3']) ? $_GET['field3'] : ''; ?>" />
            </li>

            <li>
                <input type="tel" name="field4" class="field-style" placeholder="MSISDN" value="<?php echo isset($_GET['field4']) ? $_GET['field4'] : ''; ?>" />
                <input type="date" name="from_date" class="field-style" placeholder="From Date" value="<?php echo isset($_GET['from_date']) ? $_GET['from_date'] : ''; ?>" />
                <input type="date" name="to_date" class="field-style" placeholder="To Date" value="<?php echo isset($_GET['to_date']) ? $_GET['to_date'] : ''; ?>" />
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
                    <th>MSISDN</th>
                    <th>Message Originating</th>
                    <th>Keyword</th>
                    <th>MO ID</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <?php
                if ($result->num_rows > 0) {
                    // Output data of each row
                    $index = $start_from + 1;
                    while ($row = $result->fetch_assoc()) {
                        $recvMsg = $row["recvMsg"];
                        $keywordRemark = isset($keyword_remarks[$recvMsg]) ? $keyword_remarks[$recvMsg] : '';
                        echo "<tr>
                            <td>" . $index . "</td>
                            <td>" . $row["recvPhone"] . "</td>
                            <td>" . $keywordRemark . "</td>
                            <td>" . $recvMsg . "</td>
                            <td>" . $row["recvTelcoID"] . "</td>
                            <td>" . $row["recvDate"] . "</td>
                        </tr>";
                        $index++;
                    }
                } else {
                    echo "<tr><td colspan='6'>No data available</td></tr>";
                }
                ?>
            </tbody>
        </table>
    </div>

    <!-- Pagination Links -->
    <div class="pagination">
        <?php
        if ($total_pages > 1) {
            // First page link
            echo "<a href='?page=1";
            if (!empty($where_clause)) {
                foreach ($_GET as $key => $value) {
                    if ($key != 'page') {
                        echo "&$key=$value";
                    }
                }
            }
            echo "'>&lt;&lt;</a>"; // << for first page

            $range = 2; // Number of page links to show on either side of the current page
            $showItems = 5; // Total number of pagination items to show

            // Calculate start and end range for pagination numbers
            $start = max(1, $page - $range);
            $end = min($total_pages, $page + $range);

            if ($start > 1) {
                echo "<a href='?page=1";
                if (!empty($where_clause)) {
                    foreach ($_GET as $key => $value) {
                        if ($key != 'page') {
                            echo "&$key=$value";
                        }
                    }
                }
                echo "'>1</a>";
                if ($start > 2) echo "...";
            }

            // Page numbers
            for ($i = $start; $i <= $end; $i++) {
                echo "<a href='?page=$i";
                if (!empty($where_clause)) {
                    foreach ($_GET as $key => $value) {
                        if ($key != 'page') {
                            echo "&$key=$value";
                        }
                    }
                }
                echo "'";
                if ($i == $page) echo " class='active'";
                echo ">$i</a>";
            }

            if ($end < $total_pages) {
                if ($end < $total_pages - 1) echo "...";
                echo "<a href='?page=$total_pages";
                if (!empty($where_clause)) {
                    foreach ($_GET as $key => $value) {
                        if ($key != 'page') {
                            echo "&$key=$value";
                        }
                    }
                }
                echo "'>$total_pages</a>";
            }

            // Last page link
            echo "<a href='?page=$total_pages";
            if (!empty($where_clause)) {
                foreach ($_GET as $key => $value) {
                    if ($key != 'page') {
                        echo "&$key=$value";
                    }
                }
            }
            echo "'>&gt;&gt;</a>"; // >> for last page
        }
        ?>
    </div>

    <script>
        function clearForm() {
            document.querySelectorAll('input').forEach(input => input.value = '');
            document.querySelectorAll('select').forEach(select => select.selectedIndex = 0);
        }
    </script>
</body>

</html>

<?php
$conn->close();
?>