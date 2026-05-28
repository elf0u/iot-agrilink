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
    echo json_encode(array("error" => "Connexion echouee: " . $conn->connect_error));
    exit();
}

// ── 1. Derniere prediction ──────────────────────────────────────────────────
$sql    = "SELECT * FROM predictions ORDER BY id DESC LIMIT 1";
$result = $conn->query($sql);
$prediction = null;

if ($result && $result->num_rows > 0) {
    $prediction = $result->fetch_assoc();
}

// ── 2. Derniere mesure capteur ──────────────────────────────────────────────
$sql2    = "SELECT temperature, humidity FROM sensor_data ORDER BY id DESC LIMIT 1";
$result2 = $conn->query($sql2);
$temp = null;
$hum  = null;

if ($result2 && $result2->num_rows > 0) {
    $row  = $result2->fetch_assoc();
    $temp = floatval($row['temperature']);
    $hum  = floatval($row['humidity']);
}

// ── 3. Info par plante ─────────────────────────────────────────────────────
function getPlanteInfo($nom) {
    $nom = strtolower(trim($nom));
    $infos = array(
        "citronnier"    => array("temp" => "20-30C", "hum" => "60-75%"),
        "figuier"       => array("temp" => "18-28C", "hum" => "50-65%"),
        "tomate"        => array("temp" => "20-28C", "hum" => "60-80%"),
        "laitue"        => array("temp" => "15-20C", "hum" => "50-70%"),
        "basilic"       => array("temp" => "20-30C", "hum" => "60-80%"),
        "poivron"       => array("temp" => "20-28C", "hum" => "55-70%"),
        "bananier"      => array("temp" => "25-35C", "hum" => "70-90%"),
        "gingembre"     => array("temp" => "22-30C", "hum" => "70-85%"),
        "olivier"       => array("temp" => "15-25C", "hum" => "40-60%"),
        "pommier"       => array("temp" => "12-22C", "hum" => "55-70%"),
        "romarin"       => array("temp" => "18-28C", "hum" => "30-50%"),
        "vigne"         => array("temp" => "15-28C", "hum" => "40-60%"),
        "lavande"       => array("temp" => "18-28C", "hum" => "30-50%"),
        "grenadier"     => array("temp" => "18-28C", "hum" => "40-55%"),
        "brocoli"       => array("temp" => "10-18C", "hum" => "65-80%"),
        "chou"          => array("temp" => "10-18C", "hum" => "65-80%"),
        "ail"           => array("temp" => "10-20C", "hum" => "60-75%"),
        "oignon"        => array("temp" => "10-20C", "hum" => "60-75%"),
        "menthe"        => array("temp" => "12-20C", "hum" => "65-80%"),
        "cactus"        => array("temp" => "20-40C", "hum" => "10-30%"),
        "aloe vera"     => array("temp" => "18-30C", "hum" => "20-40%"),
        "sapin"         => array("temp" => "0-15C",  "hum" => "60-80%"),
        "pin"           => array("temp" => "5-20C",  "hum" => "50-70%"),
        "mache"         => array("temp" => "5-15C",  "hum" => "60-75%"),
        "cresson"       => array("temp" => "5-15C",  "hum" => "70-85%"),
        "fraise"        => array("temp" => "18-26C", "hum" => "50-70%"),
        "courgette"     => array("temp" => "18-28C", "hum" => "55-75%"),
        "carotte"       => array("temp" => "15-20C", "hum" => "50-65%"),
        "canne a sucre" => array("temp" => "25-35C", "hum" => "70-85%"),
        "laurier-rose"  => array("temp" => "20-30C", "hum" => "40-60%"),
        "epicea"        => array("temp" => "0-15C",  "hum" => "60-80%"),
        "genevrier"     => array("temp" => "0-20C",  "hum" => "40-65%"),
        "chene"         => array("temp" => "5-25C",  "hum" => "50-70%"),
    );
    if (isset($infos[$nom])) {
        return $infos[$nom];
    }
    return array("temp" => "15-30C", "hum" => "50-70%");
}

// ── 4. Construire condition selon T et H ───────────────────────────────────
function getCondition($temp, $hum) {
    if ($temp === null || $hum === null) {
        return array("condition" => "Inconnu", "emoji" => "?", "conseil" => "Donnees insuffisantes");
    }
    if ($temp >= 25 && $hum >= 70) {
        return array("condition" => "Chaud et humide",       "emoji" => "Tropical", "conseil" => "Conditions tropicales ideales");
    } else if ($temp >= 25 && $hum < 50) {
        return array("condition" => "Chaud et sec",          "emoji" => "Aride",    "conseil" => "Conditions arides, plantes resistantes recommandees");
    } else if ($temp >= 20 && $temp < 25 && $hum >= 60) {
        return array("condition" => "Doux et humide",        "emoji" => "Doux",     "conseil" => "Conditions ideales pour agrumes et fruits");
    } else if ($temp >= 15 && $temp < 25 && $hum >= 50 && $hum < 70) {
        return array("condition" => "Tempere et modere",     "emoji" => "Tempere",  "conseil" => "Conditions ideales pour legumes et herbes");
    } else if ($temp >= 10 && $temp < 20 && $hum >= 65) {
        return array("condition" => "Frais et humide",       "emoji" => "Hiver",    "conseil" => "Bonnes conditions pour legumes d hiver");
    } else if ($temp < 10) {
        return array("condition" => "Trop froid",            "emoji" => "Froid",    "conseil" => "Temperature trop basse, chauffage recommande");
    } else {
        return array("condition" => "Conditions normales",   "emoji" => "Normal",   "conseil" => "Conditions acceptables pour la plupart des plantes");
    }
}

// ── 5. Construire la reponse finale ────────────────────────────────────────
$predicted_temp = ($prediction !== null && isset($prediction['predicted_temp']))
    ? $prediction['predicted_temp'] : null;

$confidence = ($prediction !== null && isset($prediction['confidence']))
    ? $prediction['confidence'] : null;

// Convertir "Citronnier, Figuier" → tableau d'objets plantes
$plantes = array();
if ($prediction !== null && isset($prediction['plant_recommendation']) && !empty($prediction['plant_recommendation'])) {
    $noms = explode(",", $prediction['plant_recommendation']);
    foreach ($noms as $nom) {
        $nom = trim($nom);
        if (!empty($nom)) {
            $info = getPlanteInfo($nom);
            $plantes[] = array(
                "nom"  => $nom,
                "temp" => $info['temp'],
                "hum"  => $info['hum']
            );
        }
    }
}

$cond = getCondition($temp, $hum);

$response = array(
    "predicted_temp"       => $predicted_temp,
    "confidence"           => $confidence,
    "temperature_actuelle" => $temp,
    "humidity_actuelle"    => $hum,
    "recommandation"       => array(
        "condition" => $cond['condition'],
        "emoji"     => $cond['emoji'],
        "conseil"   => $cond['conseil'],
        "plantes"   => $plantes
    )
);

echo json_encode($response);
$conn->close();
?>