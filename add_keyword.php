<?php
include_once("include/initialize.php");
date_default_timezone_set("Asia/Dhaka");
include_once("include/header.php");
?>

<!-- Include Toastr CSS and JS -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<!-- Form Container -->
<div class="form-container">
    <h2>Add New Keyword</h2>
    <form id="keywordForm" method="POST" class="styled-form">
        <div class="form-row">
            <!-- Keyword Field -->
            <div class="form-group">
                <label for="keyword">Keyword:</label>
                <input type="text" id="keyword" name="keyword" required />
            </div>

            <!-- Keyword Category Field -->
            <div class="form-group">
                <label for="keywordCategory">Keyword Category:</label>
                <input type="text" id="keywordCategory" name="keywordCategory" required />
            </div>
        </div>

        <div class="form-row">
            <!-- Keyword Remarks Field -->
            <div class="form-group">
                <label for="keywordRemarks">Keyword Remarks:</label>
                <input type="text" id="keywordRemarks" name="keywordRemarks" required />
            </div>

            <!-- Telco ID Dropdown -->
            <div class="form-group">
                <label for="telcoId">Telco ID:</label>
                <select id="telcoId" name="telcoId" required>
                    <option value="">Select Telco</option>
                    <option value="1">Grameen Phone</option>
                    <option value="2">Banglalink</option>
                </select>
            </div>
        </div>

        <!-- Submit Button -->
        <div class="form-row">
            <button type="submit" class="submit-btn">Add Keyword</button>
        </div>
    </form>
</div>

<!-- Include jQuery and jQuery UI (for the Datepicker) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<!-- Initialize Datepicker -->
<script>
    $(document).ready(function() {
        // Initialize the datepicker
        $("#datepicker").datepicker({
            dateFormat: 'yy-mm-dd'
        });

        // Handle form submission with AJAX
        $('#keywordForm').on('submit', function(event) {
            event.preventDefault(); 

            $.ajax({
                url: 'process_add_keyword.php',
                type: 'POST',
                data: $(this).serialize(),
                success: function(response) {
                    // Parse the JSON response from the server
                    const res = JSON.parse(response);
                    if (res.success) {
                        toastr.success(res.message); 
                        $('#keywordForm')[0].reset(); 
                    } else {
                        toastr.error(res.message);
                    }
                },
                error: function() {
                    toastr.error('An error occurred while processing the request.');
                }
            });
        });
    });
</script>


<!-- Styling -->
<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f5f5f5;
        margin: 0;
        padding: 0;
    }

    .form-container {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        width: 97%;
        margin: 40px auto;
        padding: 20px 40px;
    }

    .form-container h2 {
        text-align: center;
        color: #333;
        margin-bottom: 20px;
        font-size: 1.8em;
    }

    .styled-form {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .form-row {
        display: flex;
        justify-content: space-between;
        gap: 20px;
    }

    .form-group {
        flex: 1;
        display: flex;
        flex-direction: column;
    }

    label {
        font-weight: bold;
        margin-bottom: 8px;
        color: #555;
    }

    input[type="text"],
    select {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 16px;
        color: #333;
        transition: border-color 0.3s;
        width: 100%;
    }

    input[type="text"]:focus,
    select:focus {
        border-color: #007bff;
        outline: none;
    }

    .submit-btn {
        color: white;
        padding: 7px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 13px;
        transition: background-color 0.3s ease;
        width: 12%;
        max-width: 150px;
        margin: 0 auto;
        display: block;
        background-image: linear-gradient(178.7deg, rgba(126, 184, 253, 1) 5.6%, rgba(2, 71, 157, 1) 95.3%);
    }

    .submit-btn:hover {
        background-image: linear-gradient(93.2deg, rgba(24, 95, 246, 1) 14.4%, rgba(27, 69, 166, 1) 90.8%);
        transition: background-position 0.5s ease;
    }

    @media (max-width: 768px) {
        .form-container {
            width: 90%;
            padding: 20px;
        }

        .form-row {
            flex-direction: column;
        }
    }
</style>