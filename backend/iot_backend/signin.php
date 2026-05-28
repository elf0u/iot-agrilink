<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

require_once "db.php";

$data = json_decode(file_get_contents("php://input"), true);

$email = isset($data["email"]) ? trim($data["email"]) : "";
$password = isset($data["password"]) ? trim($data["password"]) : "";
$app_type = isset($data["app_type"]) ? trim($data["app_type"]) : "";

if ($email == "" || $password == "" || $app_type == "") {
    echo json_encode(array(
        "success" => false,
        "message" => "Email et mot de passe obligatoires"
    ));
    exit;
}

try {
    $hashedPassword = hash("sha256", $password);

    $stmt = $pdo->prepare(
        "SELECT * FROM users WHERE email = ? AND password = ? AND app_type = ?"
    );
    $stmt->execute(array($email, $hashedPassword, $app_type));

    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        echo json_encode(array(
            "success" => false,
            "message" => "Email ou mot de passe incorrect"
        ));
        exit;
    }

    echo json_encode(array(
        "success" => true,
        "message" => "Connexion reussie",
        "user" => array(
            "id" => $user["id"],
            "fullname" => $user["fullname"],
            "email" => $user["email"],
            "app_type" => $user["app_type"]
        )
    ));

} catch (Exception $e) {
    echo json_encode(array(
        "success" => false,
        "message" => "Erreur serveur"
    ));
}
?>