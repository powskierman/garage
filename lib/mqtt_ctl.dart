// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('192.168.0.10', 'remote');
final builder = MqttClientPayloadBuilder();
var pubTopic = 'Remote';
var pongCount = 0;
Future<int> connect() async {
  client.logging(on: true);
  client.setProtocolV311();
  client.keepAlivePeriod = 2000;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  client.pongCallback = pong;

  final connMess = MqttConnectMessage()
      .withClientIdentifier('remote')
      .withWillTopic('willTopic')
      .withWillMessage('remote MQTT has gone down')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  print('Remote connecting ....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('Remote exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    print('Remote socket exception - $e');
    client.disconnect();
  }

  // Are we connected?
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('Remote connected ....');
  } else {
    print(
        ' Error:  Remote connection failed! - disconnecting.  Status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }
  //Subscribing
  print('Connecting to Remote topic');
  const topic = 'Remote';
  client.subscribe(topic, MqttQos.atMostOnce);

  //Listen for notifiers
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print(
        'Remote change notification:: topic is <${c[0].topic}>, payload is <-- $pt-->');
  });

  //Listen to topic for published messages
  client.published!.listen((MqttPublishMessage message) {
    print(
        'Remote::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });
  return 0;
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('Remote::Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('Remote::OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('Remote::OnDisconnected callback is solicited, this is correct');
  } else {
    print(
        'Remote::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    exit(-1);
  }
  if (pongCount == 3) {
    print('Remote:: Pong count is correct');
  } else {
    print('Remote:: Pong count is incorrect, expected 3. actual $pongCount');
  }
}

/// The successful connect callback
void onConnected() {
  print(
      'Remote::OnConnected client callback - Client connection was successful');
}

/// Pong callback
void pong() {
  print('Remote::Ping response client callback invoked');
  pongCount++;
}
