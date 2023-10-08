import 'package:flutter/material.dart';

import '../providers/mqtt_service.dart';


class MqttScreen extends StatefulWidget {
  const MqttScreen({super.key});

  @override
  _MqttScreenState createState() => _MqttScreenState();
}

class _MqttScreenState extends State<MqttScreen> {
  final MqttService _mqttProvider = MqttService();

  @override
  void initState() {
    super.initState();
    _mqttProvider.mqttConnect();
  }

  @override
  void dispose() {
    _mqttProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Client'),
      ),
      body: Column(
        children: <Widget>[
          Text('Connection Status: ${_mqttProvider.statusText}'),

          Expanded(
            child: StreamBuilder<String>(
              stream: _mqttProvider.messages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  _mqttProvider.receivedMessages.add(snapshot.data!);
                  return ListView.builder(
                    itemCount: _mqttProvider.receivedMessages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_mqttProvider.receivedMessages[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}