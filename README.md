# IoT AgriLink

IoT AgriLink is a smart agriculture project that combines **IoT**, **Artificial Intelligence**, and a **mobile application** to help users monitor agricultural conditions and make better decisions.

The system collects environmental data from sensors, stores it in a database, displays it in a Flutter mobile application, generates alerts, provides plant recommendations using machine learning, and includes an image-based plant diagnosis module.

---

## Project Overview

The main goal of this project is to provide a smart agriculture solution that helps users:

- Monitor temperature, air humidity, and soil humidity
- Visualize real-time and historical sensor data
- Receive alerts when conditions become critical
- Get AI-based temperature prediction and plant recommendations
- Diagnose plant diseases from images
- Use AgriLink, a community space for sharing posts and agricultural experiences

This project was developed as a final year project.

---

## Main Features

### IoT Monitoring

- Collects temperature and humidity data using sensors
- Reads soil humidity values
- Sends sensor data through MQTT
- Stores collected data in MySQL

### Mobile Application

- Built with Flutter and Dart
- User authentication
- IoT dashboard
- Historical charts
- Alerts screen
- AI prediction display
- Plant diagnosis screen
- AgriLink community section

### Artificial Intelligence

- Temperature prediction using Random Forest Regressor
- Plant recommendation based on collected conditions
- Plant disease image diagnosis using TensorFlow Lite

### AgriLink Community

- User registration and login
- Community feed
- Post creation
- User profile screen

---

## Technologies Used

### Mobile

- Flutter
- Dart

### Backend

- PHP
- MySQL
- EasyPHP / Apache

### IoT

- Heltec LoRa V3
- DHT11 sensor
- Soil humidity sensor
- MQTT

### Artificial Intelligence

- Python
- Random Forest Regressor
- TensorFlow Lite
- Google Colab

### Tools

- Visual Studio Code
- Android Studio
- phpMyAdmin
- Arduino IDE

---

## Project Structure

```text
iot-agrilink/
│
├── lib/                     # Flutter application source code
├── assets/                  # Assets and ML model files
├── android/                 # Android Flutter project files
├── ios/                     # iOS Flutter project files
│
├── backend/                 # PHP backend files
│   └── iot_backend/
│       ├── db.php
│       ├── signup.php
│       ├── signin.php
│       ├── get_chart_data.php
│       ├── get_prediction.php
│       └── analyze_plant.php
│
├── database/                # Database SQL file
│   └── iot_project.sql
│
├── python/                  # Python scripts
│   ├── mqtt_to_mysql.py
│   └── ai models/
│       ├── ai_model.py
│       └── models/
│           └── model.pkl
│
├── arduino/                 # Arduino / Heltec code
│   └── code heltec lora.txt
│
├── pubspec.yaml
└── README.md
