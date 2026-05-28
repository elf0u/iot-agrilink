<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

require_once "db.php";

$data = json_decode(file_get_contents("php://input"), true);

$fullname = isset($data["fullname"]) ? trim($data["fullname"]) : "";
$email = isset($data["email"]) ? trim($data["email"]) : "";
$password = isset($data["password"]) ? trim($data["password"]) : "";
$app_type = isset($data["app_type"]) ? trim($data["app_type"]) : "";

if ($fullname == "" || $email == "" || $password == "" || $app_type == "") {
    echo json_encode(array(
        "success" => false,
        "message" => "Tous les champs sont obligatoires"
    ));
    exit;
}

if ($app_type != "iot" && $app_type != "agrilink") {
    echo json_encode(array(
        "success" => false,
        "message" => "Type application invalide"
    ));
    exit;
}

try {
    $check = $pdo->prepare("SELECT id FROM users WHERE email = ? AND app_type = ?");
    $check->execute(array($email, $app_type));

    if ($check->rowCount() > 0) {
        echo json_encode(array(
            "success" => false,
            "message" => "Email deja utilise"
        ));
        exit;
    }

    $hashedPassword = hash("sha256", $password);

    $stmt = $pdo->prepare(
        "INSERT INTO users (fullname, email, password, app_type) VALUES (?, ?, ?, ?)"
    );

    $stmt->execute(array($fullname, $email, $hashedPassword, $app_type));

    echo json_encode(array(
        "success" => true,
        "message" => "Compte cree avec succes"
    ));

} catch (Exception $e) {
    echo json_encode(array(
        "success" => false,
        "message" => "Erreur serveur"
    ));
}
?>