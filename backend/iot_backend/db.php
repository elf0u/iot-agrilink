<?php
header("Content-Type: application/json");

$host = "localhost";
$dbname = "iot_project";
$username = "root";
$password = "";

try {
    $dsn = "mysql:host=" . $host . ";dbname=" . $dbname . ";charset=utf8";

    $pdo = new PDO($dsn, $username, $password);

    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch (PDOException $e) {
    echo json_encode(array(
        "success" => false,
        "message" => "Database connection failed"
    ));
    exit;
}
?>