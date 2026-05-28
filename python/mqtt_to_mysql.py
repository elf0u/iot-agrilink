import paho.mqtt.client as mqtt
import mysql.connector

# Configuration
MQTT_BROKER = "192.168.1.6"
##MQTT_BROKER = "172.16.29.143"
MQTT_PORT = 1883
DB_CONFIG = {
    'host': 'localhost',
    'database': 'iot_project',
    'user': 'root',
    'password': ''
}

temp_value = None
hum_value  = None
sol_value  = None  # ← NOUVEAU

# Connexion base de données
print("🔗 Connexion MySQL...")
db = mysql.connector.connect(**DB_CONFIG)
cursor = db.cursor()
print("✅ MySQL connecté !")

def on_connect(client, userdata, flags, rc):
    print(f"✅ MQTT connecté (code: {rc})")
    client.subscribe("iot/temperature")
    client.subscribe("iot/humidity")
    client.subscribe("iot/sol")   # ← NOUVEAU
    print("📡 Abonné aux topics IoT")

def on_message(client, userdata, msg):
    global temp_value, hum_value, sol_value

    try:
        value = float(msg.payload.decode())
        topic = msg.topic

        print(f"📨 {topic}: {value}")

        if topic == "iot/temperature":
            temp_value = value
        elif topic == "iot/humidity":
            hum_value = value
        elif topic == "iot/sol":       # ← NOUVEAU
            sol_value = value

        # Sauvegarder quand on a les 3 valeurs
        if temp_value is not None and hum_value is not None and sol_value is not None:
            cursor.execute(
                "INSERT INTO sensor_data (temperature, humidity, sol) VALUES (%s, %s, %s)",
                (temp_value, hum_value, sol_value)
            )
            db.commit()
            print(f"✅ SAUVEGARDÉ: T={temp_value:.1f}°C  H={hum_value:.1f}%  Sol={sol_value}")
            temp_value = None
            hum_value  = None
            sol_value  = None   # ← NOUVEAU

    except Exception as e:
        print(f"❌ Erreur: {e}")

# Client MQTT
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

print("🔄 Connexion MQTT...")
client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_forever()