<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$conn = new mysqli("localhost", "root", "", "iot_project");

if ($conn->connect_error) {
    echo json_encode(array("error" => "Connexion echouee"));
    exit();
}

// Seulement les lignes où sol n'est pas NULL
$sql = "SELECT temperature, humidity, sol, created_at 
        FROM sensor_data 
        WHERE sol IS NOT NULL 
        ORDER BY id DESC 
        LIMIT 20";

$result = $conn->query($sql);

$rows = array();
if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Conversion en float pour Flutter
        $rows[] = array(
            "temperature" => floatval($row['temperature']),
            "humidity"    => floatval($row['humidity']),
            "sol"         => intval($row['sol']),
            "created_at"  => $row['created_at']
        );
    }
    $rows = array_reverse($rows);
}

echo json_encode(array("data" => $rows));

$conn->close();
?>