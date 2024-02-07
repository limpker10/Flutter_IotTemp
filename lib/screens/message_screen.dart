import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../providers/mqtt_service.dart';
import '../widgets/utils.dart';

class MqttScreen extends StatefulWidget {
  const MqttScreen({super.key});

  @override
  _MqttScreenState createState() => _MqttScreenState();
}

class _MqttScreenState extends State<MqttScreen> {
  final MqttService _mqttProvider = MqttService();
  double temperature = 0.0; // Variable para almacenar la temperatura
  int humedad = 0; // Variable para almacenar la temperatura

  @override
  void initState() {
    super.initState();
    _mqttProvider.mqttConnect();

    // Escucha los mensajes MQTT y actualiza la temperatura cuando se recibe un mensaje
    _mqttProvider.messages.listen((message) {
      try {
        // Analizar el JSON del mensaje
        final jsonData = jsonDecode(message);
        final receivedTemperature = jsonData["temperature"] as double;
        final receivedHumedad = jsonData["humidity"] as int;

        setState(() {
          temperature = receivedTemperature;
          humedad = receivedHumedad;
        });
      } catch (e) {
        print("Error al analizar el mensaje MQTT: $e");
      }
    });
  }

  @override
  void dispose() {
    _mqttProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.indigo,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.login,
              color: Colors.blue,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Column(
              children: [
                Text(
                  'Temperature',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
                ),
                Text(
                  'Living room',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SleekCircularSlider(
                  min: 0,
                  max: 100,
                  initialValue: temperature,
                  appearance: CircularSliderAppearance(
                    size: 280,
                    startAngle: 140,
                    angleRange: 260,
                    customWidths: CustomSliderWidths(
                      trackWidth: 25,
                      shadowWidth: 20,
                      progressBarWidth: 25,
                      handlerSize: 10,
                    ),
                    customColors: CustomSliderColors(
                      hideShadow: false,
                      progressBarColor: theme.primaryColor,
                      trackColor: Colors.grey[300],
                      dotColor: theme.primaryColor,
                    ),
                  ),
                  innerWidget: (double value) {
                    return Center(
                        child: Text(
                      '${temperature.toStringAsFixed(2)}°C', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ));
                  },
                  onChange: (double value) {
                    // Lógica adicional si es necesario
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current humidity',
                      style: TextStyle(
                        color: Colors.grey.withAlpha(150),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$humedad',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current temp.',
                      style: TextStyle(
                        color: Colors.grey.withAlpha(150),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${temperature.toStringAsFixed(2)}°C',
                      // Usa el valor de temperatura
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 35,
            ),

            Row(
              children: [
                Expanded( // Expande el widget para llenar el espacio horizontal disponible
                  child: Align(
                    alignment: Alignment.center, // Alinea el botón al centro horizontalmente
                    child: ElevatedButton(
                      onPressed: () {
                        _mqttProvider.publishMessage();
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        // Define el color de fondo para diferentes estados
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.blue; // Color cuando el botón está presionado
                          }
                          return Colors.white; // Color por defecto
                        }),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.blue.withOpacity(0.5); // Color de la "sombra" cuando está presionado
                          }
                          // Por defecto no aplicar color adicional
                          return Colors.transparent;
                        }),
                      ),
                      child: Icon(
                        Icons.airplay,
                        color: Colors.black.withAlpha(175),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
