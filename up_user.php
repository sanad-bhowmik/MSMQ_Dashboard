<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$dbhost = "localhost";
$dbusername = "root";
$dbpassword = "";
$dbname = "queue_db";

$conn = new mysqli($dbhost, $dbusername, $dbpassword, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (isset($_POST['submit'])) {
    $user_name = isset($_POST['user_name']) ? trim($_POST['user_name']) : '';
    $first_name = isset($_POST['first_name']) ? trim($_POST['first_name']) : '';
    $last_name = isset($_POST['last_name']) ? trim($_POST['last_name']) : '';
    $mobile = isset($_POST['mobile']) ? trim($_POST['mobile']) : '';
    $email = isset($_POST['email']) ? trim($_POST['email']) : '';
    $password = 'MTIz';  // Hardcoded password value
    $user_role_id = isset($_POST['user_role']) ? (int)$_POST['user_role'] : 0;

    $errors = [];
    if (empty($user_name)) $errors[] = "User Name is required.";
    if (empty($first_name)) $errors[] = "First Name is required.";
    if (empty($last_name)) $errors[] = "Last Name is required.";
    if (empty($mobile)) $errors[] = "Mobile is required.";
    if (empty($email)) $errors[] = "Email is required.";
    if (empty($password)) $errors[] = "Password is required.";
    if ($user_role_id <= 0) $errors[] = "User Role is required.";

    if (!empty($errors)) {
        foreach ($errors as $error) {
            echo "<p style='color: red;'>$error</p>";
        }
    } else {
        $stmt = $conn->prepare("INSERT INTO users (user_name, first_name, last_name, mobile, email, password, user_role_id, status, datetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

        if ($stmt === false) {
            die("Prepare failed: " . htmlspecialchars($conn->error));
        }

        $status = 'active';
        $datetime = date('Y-m-d H:i:s');

        // No password hash, directly using the hardcoded value
        $stmt->bind_param("sssssssss", $user_name, $first_name, $last_name, $mobile, $email, $password, $user_role_id, $status, $datetime);

        if ($stmt->execute()) {
            header("Location: add_user.php?success=1");
            exit();
        } else {
            echo "<p style='color: red;'>Error: " . htmlspecialchars($stmt->error) . "</p>";
        }

        $stmt->close();
    }
}

$conn->close();
