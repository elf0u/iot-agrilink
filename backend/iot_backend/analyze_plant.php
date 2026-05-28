<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// ── Cle Gemini ──
$GEMINI_KEY = "AIzaSyDxO4igd5sJGGV328w6_JbmzugcOzMtqrw";

// ── Liste modeles a essayer dans l'ordre ──
// Si un modele depasse le quota, on passe au suivant
$models = array(
    "gemini-1.5-flash-latest",
    "gemini-1.5-pro-latest",
    "gemini-pro-vision",
    "gemini-2.0-flash-lite",
    "gemini-2.0-flash"
);

// ── Recuperer image ──
$raw      = file_get_contents('php://input');
$input    = json_decode($raw, true);
$imageB64 = isset($input['image'])     ? $input['image']     : null;
$mimeType = isset($input['mime_type']) ? $input['mime_type'] : 'image/jpeg';

if (!$imageB64) {
    echo json_encode(array("error" => "Image manquante"));
    exit();
}

// ── Prompt ──
$prompt = "Tu es un expert agronome specialise dans les maladies des plantes. "
        . "Analyse cette image et reponds UNIQUEMENT en JSON valide sans texte avant ou apres. "
        . "Format exact : "
        . "{\"plante\":\"nom\",\"etat\":\"Saine\",\"maladie\":null,\"gravite\":\"Aucune\","
        . "\"symptomes\":[\"s1\"],\"traitement\":[\"t1\"],\"prevention\":[\"p1\"],\"urgence\":false} "
        . "Valeurs etat : Saine / Malade / Stress hydrique / Carence nutritive. "
        . "Valeurs gravite : Faible / Moderee / Elevee / Critique / Aucune. "
        . "Si pas une plante : plante = Non reconnu.";

// ── Corps requete ──
$body = json_encode(array(
    "contents" => array(array(
        "parts" => array(
            array("text" => $prompt),
            array("inline_data" => array(
                "mime_type" => $mimeType,
                "data"      => $imageB64
            ))
        )
    )),
    "generationConfig" => array(
        "temperature"     => 0.1,
        "maxOutputTokens" => 512
    )
));

// ── Fonction appel Gemini ──
function callGemini($url, $body) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_POST,           true);
    curl_setopt($ch, CURLOPT_POSTFIELDS,     $body);
    curl_setopt($ch, CURLOPT_HTTPHEADER,     array('Content-Type: application/json'));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_TIMEOUT,        30);
    $response  = curl_exec($ch);
    $httpCode  = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    curl_close($ch);
    return array("code" => $httpCode, "body" => $response, "error" => $curlError);
}

// ── Essayer chaque modele ──
$lastError = "Tous les modeles ont echoue";

foreach ($models as $model) {
    $url    = "https://generativelanguage.googleapis.com/v1beta/models/" . $model . ":generateContent?key=" . $GEMINI_KEY;
    $result = callGemini($url, $body);

    if ($result['error']) {
        $lastError = "Erreur cURL : " . $result['error'];
        continue;
    }

    if ($result['code'] === 429) {
        // Quota depasse → essayer modele suivant
        $lastError = "Quota depasse sur " . $model;
        continue;
    }

    if ($result['code'] === 404) {
        // Modele inexistant → essayer modele suivant
        $lastError = "Modele introuvable : " . $model;
        continue;
    }

    if ($result['code'] === 200) {
        $data = json_decode($result['body'], true);
        $text = isset($data['candidates'][0]['content']['parts'][0]['text'])
                ? $data['candidates'][0]['content']['parts'][0]['text']
                : '';

        // Nettoyer markdown
        $text = str_replace("```json", "", $text);
        $text = str_replace("```",     "", $text);
        $text = trim($text);

        // Extraire JSON
        preg_match('/\{[\s\S]*\}/', $text, $matches);

        if (!empty($matches[0])) {
            $parsed = json_decode($matches[0], true);
            if ($parsed) {
                // Ajouter le modele utilise pour debug
                $parsed['_model_used'] = $model;
                echo json_encode($parsed);
                exit();
            }
        }

        $lastError = "JSON invalide depuis " . $model;
        continue;
    }

    // Autre erreur
    $errData   = json_decode($result['body'], true);
    $errMsg    = isset($errData['error']['message'])
                 ? $errData['error']['message']
                 : "Code " . $result['code'];
    $lastError = "Erreur " . $model . " : " . $errMsg;
}

// ── Tous les modeles ont echoue ──
echo json_encode(array(
    "error"       => $lastError,
    "solution"    => "Creez une nouvelle cle API sur https://aistudio.google.com/app/apikey"
));
?>