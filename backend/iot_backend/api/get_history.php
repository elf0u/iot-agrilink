<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// PHP 5.3 n'accepte pas MYSQLI_REPORT_STRICT, donc on retire
// et on utilise un check manuel
// mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $db = new mysqli('localhost', 'root', '', 'iot_project');
    if ($db->connect_error) {
        throw new Exception('Connexion DB échouée : ' . $db->connect_error);
    }

    $db->set_charset("utf8");

    $sql = "SELECT id, temperature, humidity, sol , created_at 
            FROM sensor_data 
            ORDER BY id DESC 
            LIMIT 50";

    $result = $db->query($sql);

    $data = array();
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode(array(
        'success' => true,
        'count' => count($data),
        'data' => $data
    ));

} catch (Exception $e) {
    echo json_encode(array(
        'success' => false,
        'error' => 'DB connection failed: ' . $e->getMessage()
    ));
}

?>
