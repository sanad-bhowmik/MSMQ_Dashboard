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

// Define where conditions
$where_conditions = array();

// Handle telco_id filter
if (isset($_GET['telco_id']) && $_GET['telco_id'] != '') {
    $telco_id = $conn->real_escape_string($_GET['telco_id']);
    if ($telco_id !== 'all') { // Only add condition if not "All Telco"
        $where_conditions[] = "msgTelcoID = '$telco_id'";
    }
}

// Handle keyword ID filter
if (isset($_GET['keyword_id']) && $_GET['keyword_id'] != '') {
    $keyword_id = $conn->real_escape_string($_GET['keyword_id']);
    $where_conditions[] = "tbl_keyword.keywordID = '$keyword_id'";
}

// Handle keyword filter (MT filter)
if (isset($_GET['field3']) && $_GET['field3'] != '') {
    $messageOrigin = $conn->real_escape_string($_GET['field3']);
    $where_conditions[] = "msgText LIKE '%$messageOrigin%'";
}

// Handle MSISDN filter (Phone number filter)
if (isset($_GET['field4']) && $_GET['field4'] != '') {
    $msisdn = $conn->real_escape_string($_GET['field4']);
    $where_conditions[] = "msgTo = '$msisdn'";
}

// Handle date filters
if (isset($_GET['from_date']) && $_GET['from_date'] != '' && isset($_GET['to_date']) && $_GET['to_date'] != '') {
    $from_date = $conn->real_escape_string($_GET['from_date']);
    $to_date = $conn->real_escape_string($_GET['to_date']);
    $where_conditions[] = "msgDate BETWEEN '$from_date' AND '$to_date'";
} elseif (isset($_GET['from_date']) && $_GET['from_date'] != '') {
    $from_date = $conn->real_escape_string($_GET['from_date']);
    $where_conditions[] = "msgDate >= '$from_date'";
} elseif (isset($_GET['to_date']) && $_GET['to_date'] != '') {
    $to_date = $conn->real_escape_string($_GET['to_date']);
    $where_conditions[] = "msgDate <= '$to_date'";
}

$where_clause = '';
if (!empty($where_conditions)) {
    $where_clause = " WHERE " . implode(" AND ", $where_conditions);
}

// Pagination logic
$records_per_page = 50;
$page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
$start_from = ($page - 1) * $records_per_page;

// Get count of total records
$sql_count = "SELECT COUNT(*) AS total_records FROM tbl_outbox
              LEFT JOIN tbl_keyword ON tbl_outbox.msgKeyID = tbl_keyword.keywordID" . $where_clause;
$result_count = $conn->query($sql_count);

if (!$result_count) {
    die("Error in query: " . $conn->error);
}

$row_count = $result_count->fetch_assoc();
$total_records = $row_count['total_records'];
$total_pages = ceil($total_records / $records_per_page);

// Get the filtered records
$sql = "SELECT 
            tbl_outbox.msgTo, 
            tbl_outbox.msgText, 
            tbl_outbox.msgTelcoID, 
            tbl_outbox.msgDate,
            tbl_keyword.keyword AS Keyword
        FROM tbl_outbox
        LEFT JOIN tbl_keyword ON tbl_outbox.msgKeyID = tbl_keyword.keywordID
        " . $where_clause . " 
        ORDER BY tbl_outbox.msgDate DESC 
        LIMIT $start_from, $records_per_page";

$result = $conn->query($sql);

if (!$result) {
    die("Error in query: " . $conn->error);
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Outbound Traffic Log</title>
    <link rel="stylesheet" href="../style/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.9/xlsx.full.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.1.0-beta.1/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.1.0-beta.1/js/select2.min.js"></script>
</head>

<body>
    <form class="form-style-9" method="GET" action="">
        <h3 style="margin-top: 0;text-align: center;font-family: serif;margin-bottom: 17px;">Outbound Traffic Log</h3>
        <ul>
            <li style="gap: 10px;">
                <!-- TELCO Dropdown (Searchable) -->
                <select name="telco_id" id="telco_id" class="field-style select2" style="max-width: 427px;">
                    <option value="" selected disabled>Select TELCO</option>
                    <option value="all" <?php echo (isset($_GET['telco_id']) && $_GET['telco_id'] == 'all') ? 'selected' : ''; ?>>All TELCO</option>
                    <option value="1" <?php echo (isset($_GET['telco_id']) && $_GET['telco_id'] == '1') ? 'selected' : ''; ?>>Grameen Phone</option>
                    <option value="3" <?php echo (isset($_GET['telco_id']) && $_GET['telco_id'] == '3') ? 'selected' : ''; ?>>Banglalink</option>
                    <!-- <option value="4" <?php echo (isset($_GET['telco_id']) && $_GET['telco_id'] == '4') ? 'selected' : ''; ?>>Robi</option> -->
                </select>

                <!-- Keyword Dropdown (Searchable) -->
                <select name="keyword_id" class="field-style select2" style="max-width: 300px;">
                    <option value="" selected>Select Keyword</option>
                    <?php
                    // Fetch and display keyword options
                    $keyword_query = "SELECT keywordID, keyword FROM tbl_keyword";
                    $keyword_result = $conn->query($keyword_query);

                    if (!$keyword_result) {
                        die("Error in query: " . $conn->error);
                    }

                    while ($keyword_row = $keyword_result->fetch_assoc()) {
                        $selected = (isset($_GET['keyword_id']) && $_GET['keyword_id'] == $keyword_row['keywordID']) ? 'selected' : '';
                        echo "<option value='{$keyword_row['keywordID']}' $selected>{$keyword_row['keyword']}</option>";
                    }
                    ?>
                </select>

                <input type="text" style="width: 300px;box-sizing: border-box;border-radius: 3px;border: 1px solid #afa5a5;height: 28px;margin-right: 0;" name="field3" class="field-style" placeholder="MT" value="<?php echo isset($_GET['field3']) ? $_GET['field3'] : ''; ?>" />
            </li>

            <li>
                <input type="text" name="field4" class="field-style" placeholder="Phone Number" value="<?php echo isset($_GET['field4']) ? $_GET['field4'] : ''; ?>" />
                <input type="date" name="from_date" class="field-style" placeholder="From Date" value="<?php echo isset($_GET['from_date']) ? $_GET['from_date'] : ''; ?>" />
                <input type="date" name="to_date" class="field-style" placeholder="To Date" value="<?php echo isset($_GET['to_date']) ? $_GET['to_date'] : ''; ?>" />
                <input type="submit" name="search" value="Search" style="margin-right: 3px;">
                <input type="button" class="clear-button" value="Clear" onclick="clearForm()" style="margin-right: 6px;">
                <button class="container-btn-file" id="download-excel" type="button">
                    <svg
                        fill="#fff"
                        xmlns="http://www.w3.org/2000/svg"
                        width="16"
                        height="16"
                        viewBox="0 0 50 50">
                        <path
                            d="M28.8125 .03125L.8125 5.34375C.339844 
                              5.433594 0 5.863281 0 6.34375L0 43.65625C0 
                              44.136719 .339844 44.566406 .8125 44.65625L28.8125 
                              49.96875C28.875 49.980469 28.9375 50 29 50C29.230469 
                              50 29.445313 49.929688 29.625 49.78125C29.855469 49.589844 
                              30 49.296875 30 49L30 1C30 .703125 29.855469 .410156 29.625 
                              .21875C29.394531 .0273438 29.105469 -.0234375 28.8125 .03125ZM32 
                              6L32 13L34 13L34 15L32 15L32 20L34 20L34 22L32 22L32 27L34 27L34 
                              29L32 29L32 35L34 35L34 37L32 37L32 44L47 44C48.101563 44 49 
                              43.101563 49 42L49 8C49 6.898438 48.101563 6 47 6ZM36 13L44 
                              13L44 15L36 15ZM6.6875 15.6875L11.8125 15.6875L14.5 21.28125C14.710938 
                              21.722656 14.898438 22.265625 15.0625 22.875L15.09375 22.875C15.199219 
                              22.511719 15.402344 21.941406 15.6875 21.21875L18.65625 15.6875L23.34375 
                              15.6875L17.75 24.9375L23.5 34.375L18.53125 34.375L15.28125 
                              28.28125C15.160156 28.054688 15.035156 27.636719 14.90625 
                              27.03125L14.875 27.03125C14.8125 27.316406 14.664063 27.761719 
                              14.4375 28.34375L11.1875 34.375L6.1875 34.375L12.15625 25.03125ZM36 
                              20L44 20L44 22L36 22ZM36 27L44 27L44 29L36 29ZM36 35L44 35L44 37L36 37Z"></path>
                    </svg>
                </button>
            </li>
        </ul>
    </form>
    <div class="table-wrapper">
        <table class="fl-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Phone</th>
                    <th>MT</th>
                    <th>Keyword</th>
                    <th>Telco ID</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <?php if ($result->num_rows > 0): ?>
                    <?php $index = 1; ?>
                    <?php while ($row = $result->fetch_assoc()): ?>
                        <?php
                        // Map the msgTelcoID value to the corresponding telecom operator name
                        $telco_name = '';
                        switch ($row['msgTelcoID']) {
                            case '1':
                                $telco_name = 'Grameen Phone';
                                break;
                            case '3':
                                $telco_name = 'Banglalink';
                                break;
                            case '4':
                                $telco_name = 'Robi';
                                break;
                            default:
                                $telco_name = 'Unknown';
                        }
                        ?>
                        <tr>
                            <td><?php echo $index++; ?></td>
                            <td><?php echo htmlspecialchars($row['msgTo']); ?></td>
                            <td><?php echo htmlspecialchars($row['msgText']); ?></td>
                            <td><?php echo htmlspecialchars($row['Keyword']); ?></td>
                            <td><?php echo htmlspecialchars($telco_name); ?></td>
                            <td><?php echo date('d-m-Y H:i:s', strtotime($row['msgDate'])); ?></td>
                        </tr>
                    <?php endwhile; ?>
                <?php else: ?>
                    <tr>
                        <td colspan="6" style="font-size: large;color: red;font-weight: 700;font-family: monospace;">No records found</td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>

    <div class="pagination">
        <?php
        // Display pagination links
        if ($total_pages > 1) {
            for ($i = 1; $i <= $total_pages; $i++) {
                echo "<a href='?page=$i'>" . $i . "</a> ";
            }
        }
        ?>
    </div>

    <script>
        function clearForm() {
            window.location.href = window.location.pathname;
        }
        $(document).ready(function() {
            $('#download-excel').on('click', function() {
                var wb = XLSX.utils.book_new();

                var table = $('.fl-table')[0];
                var ws = XLSX.utils.table_to_sheet(table);

                XLSX.utils.book_append_sheet(wb, ws, "Inbound Traffic Log");

                XLSX.writeFile(wb, 'Outbound_Traffic_Log.xlsx');
            });
        });
        $(document).ready(function() {
            $('#telco_id').select2({
                placeholder: "Select TELCO",
                allowClear: true
            });

            $('select[name="keyword_id"]').select2({
                placeholder: "Select Keyword",
                allowClear: true
            });

            $('#telco_id').next('.select2-container').css('width', '300px');
            $('select[name="keyword_id"]').next('.select2-container').css('width', '300px');
        });
    </script>
</body>

</html>

<?php
$conn->close();
?>




<style>
    .container-btn-file {
        cursor: pointer;
        display: flex;
        position: relative;
        justify-content: center;
        align-items: center;
        background-color: #307750;
        color: #fff;
        border-style: none;
        padding: 1em 2em;
        border-radius: 0.5em;
        overflow: hidden;
        z-index: 1;
        box-shadow: 4px 8px 10px -3px rgba(0, 0, 0, 0.356);
        transition: all 250ms;
    }

    .container-btn-file input[type="file"] {
        position: absolute;
        width: 100%;
        height: 100%;
        opacity: 0;
        cursor: pointer;
    }

    .container-btn-file::before {
        content: "";
        position: absolute;
        height: 100%;
        width: 0;
        border-radius: 0.5em;
        background-color: #469b61;
        z-index: -1;
        transition: all 350ms;
    }

    .container-btn-file:hover::before {
        width: 100%;
    }

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