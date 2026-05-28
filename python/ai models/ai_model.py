# ======================
# LIBS
# ======================
import mysql.connector
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
import joblib
import paho.mqtt.client as mqtt
import traceback
import os
import sys

# ======================
# CONFIG
# ======================
BROKER_IP   = "192.168.1.6"
BROKER_PORT = 1883
TOPIC_TEMP  = "iot/temperature"
TOPIC_HUM   = "iot/humidity"

DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",
    "password": "",
    "database": "iot_project"
}

# ── Chemin absolu pour éviter les problèmes de permissions ── NOUVEAU
BASE_DIR   = os.path.dirname(os.path.abspath(__file__))
MODELS_DIR = os.path.join(BASE_DIR, "models")
MODEL_PATH = os.path.join(MODELS_DIR, "model.pkl")

# ======================
# VARIABLES GLOBALES
# ======================
last_temperature = None
last_humidity    = None


# ======================
# PLANT RECOMMENDATION
# ======================
def get_plant_recommendation(temp, humidity):
    humid = humidity is not None and humidity >= 60

    if temp < 5:
        return "Sapin, Epicea, Genevrier"
    elif temp < 10:
        return "Pin, Chene, Lavande"
    elif temp < 15:
        return "Olivier, Pommier" if humid else "Romarin, Vigne"
    elif temp < 20:
        return "Tomate, Laitue" if humid else "Basilic, Poivron"
    elif temp < 25:
        return "Citronnier, Figuier" if humid else "Grenadier"
    elif temp < 30:
        return "Bananier, Gingembre" if humid else "Laurier-rose"
    elif temp < 35:
        return "Canne a sucre" if humid else "Aloe vera, Cactus"
    else:
        return "Plantes desertiques"


# ======================
# PREDICTION
# ======================
def run_prediction():
    print("Lancement de la prediction...")

    conn = None

    try:
        conn = mysql.connector.connect(**DB_CONFIG)

        # ── SQLAlchemy pour éviter le UserWarning pandas ── NOUVEAU
        from sqlalchemy import create_engine
        engine = create_engine(
            f"mysql+mysqlconnector://root:@localhost/iot_project"
        )
        df = pd.read_sql_query(
            "SELECT temperature, humidity FROM sensor_data ORDER BY id ASC",
            engine
        )

        df = df.dropna()

        if len(df) < 10:
            print("Pas assez de donnees")
            return

        df["time_index"] = range(len(df))

        X = df[["time_index", "humidity"]]
        y = df["temperature"]

        model = RandomForestRegressor(n_estimators=100, random_state=42)
        model.fit(X, y)

        mae = mean_absolute_error(y, model.predict(X))
        print(f"MAE : {mae:.4f}")

        next_input = pd.DataFrame(
            [[len(df), df["humidity"].iloc[-1]]],
            columns=["time_index", "humidity"]
        )

        predicted_temp     = float(model.predict(next_input)[0])
        current_humidity   = float(df["humidity"].iloc[-1])
        recommendation     = get_plant_recommendation(predicted_temp, current_humidity)

        print(f"Temperature predite : {predicted_temp:.2f}")
        print(f"Humidite            : {current_humidity:.1f}%")
        print(f"Plantes             : {recommendation}")

        # ── INSERT DB ──
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO predictions (predicted_temp, humidity, plant_recommendation)
            VALUES (%s, %s, %s)
        """, (predicted_temp, current_humidity, recommendation))
        conn.commit()
        cursor.close()

        # ── SAVE MODEL avec chemin absolu ── NOUVEAU
        try:
            os.makedirs(MODELS_DIR, exist_ok=True)
            joblib.dump(model, MODEL_PATH)
            print(f"Modele sauvegarde : {MODEL_PATH}")
        except PermissionError as pe:
            print(f"Modele non sauvegarde (permission refusee) : {pe}")
        except Exception as me:
            print(f"Modele non sauvegarde : {me}")

        print("-" * 50)

    except Exception as e:
        print("Erreur prediction:", e)
        traceback.print_exc()

    finally:
        if conn:
            conn.close()


# ======================
# MQTT
# ======================
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("MQTT connecte")
        client.subscribe(TOPIC_TEMP)
        client.subscribe(TOPIC_HUM)
    else:
        print("MQTT erreur:", rc)


def on_message(client, userdata, msg):
    global last_temperature, last_humidity

    try:
        value = float(msg.payload.decode().strip())
        print(f"MQTT {msg.topic}: {value}")
    except Exception:
        print("Valeur invalide recue")
        return

    if msg.topic == TOPIC_TEMP:
        last_temperature = value

    elif msg.topic == TOPIC_HUM:
        last_humidity = value
        if last_temperature is not None:
            run_prediction()
            last_temperature = None
            last_humidity    = None


# ======================
# MAIN
# ======================
if __name__ == "__main__":
    print("Service IA demarre")
    print(f"Dossier modeles : {MODELS_DIR}")

    # ── Vérification permissions au démarrage ── NOUVEAU
    try:
        os.makedirs(MODELS_DIR, exist_ok=True)
        test_file = os.path.join(MODELS_DIR, "test.tmp")
        with open(test_file, "w") as f:
            f.write("ok")
        os.remove(test_file)
        print("Dossier models : OK")
    except PermissionError:
        print(f"ERREUR : impossible d'ecrire dans {MODELS_DIR}")
        print("Solution : lancez le script en tant qu'Administrateur")
        print("Ou changez les permissions du dossier C:\\iot_project\\models")
        sys.exit(1)

    client = mqtt.Client(client_id="prediction_service")
    client.on_connect = on_connect
    client.on_message = on_message

    try:
        client.connect(BROKER_IP, BROKER_PORT, 60)
        client.loop_forever()
    except KeyboardInterrupt:
        print("Arret manuel")
        client.disconnect()
    except Exception as e:
        print("Erreur:", e)