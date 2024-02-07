import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class MqttService {
  bool _isConnected = false;
  String _statusText = 'Disconnected';
  String topic = 'mosquitto/aws';
  final TextEditingController idTextController = TextEditingController();
  final List<String> _receivedMessages = [];
  int _lastValue = 0;

  final StreamController<String> _messageController = StreamController<String>.broadcast();
  Stream<String> get messages => _messageController.stream;

  bool get isConnected => _isConnected;
  String get statusText => _statusText;
  List<String> get receivedMessages => _receivedMessages;

  final MqttServerClient _client =
  MqttServerClient('ajc0lzc2wmskx-ats.iot.us-east-2.amazonaws.com', '');

  Future<void> connectToMQTT() async {
    if (idTextController.text.trim().isNotEmpty) {
      _isConnected = await mqttConnect();
    }
  }

  Future<bool> mqttConnect() async {
    setStatus("Connecting MQTT Broker");

    // After adding your certificates to the pubspec.yaml, you can use Security Context.
    ByteData rootCA = await rootBundle.load('assets/certs/AmazonRootCA1.pem');
    ByteData deviceCert = await rootBundle.load('assets/certs/Certificate.crt');
    ByteData privateKey = await rootBundle.load('assets/certs/private.key');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

    _client.securityContext = context;

    _client.logging(on: true);
    _client.keepAlivePeriod = 20;
    _client.port = 8883;
    _client.secure = true;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.pongCallback = pong;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(generateUniqueClientId())
        .startClean();
    _client.connectionMessage = connMess;

    await _client.connect();
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      onConnected();
      debugPrint("Connected to AWS Successfully!");

      _client.subscribe(topic, MqttQos.atMostOnce);
      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        _receivedMessages.add(message);
        _messageController
            .add(message); // Agrega el mensaje al StreamController

      });

      return true;
    } else {
      return false;
    }
  }
  void publishMessage() {
    String topic = 'aws/sub';
    _lastValue = _lastValue == 75 ? 0 : 75;
    var jsonCommand = {
      "value": "$_lastValue"
    };
    String message = json.encode(jsonCommand);
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? handleReceivedData() {
    return _client.updates;
  }

  String generateUniqueClientId() {
    const uuid = Uuid();
    return 'mqtt_client_${uuid.v4()}';
  }

  void setStatus(String content) {
    _statusText = content;
  }

  void onConnected() {
    setStatus("Client connection was successful");
  }

  void onDisconnected() {
    setStatus("Client Disconnected");
    _isConnected = false;
  }

  void pong() {
    debugPrint('Ping response client callback invoked');
  }

  void dispose() {
    _messageController.close();
  }
}