// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
//import 'value_notifiers.dart';

final client = MqttServerClient('192.168.0.10', 'remote');
final builder = MqttClientPayloadBuilder();
//ValueNotifier<Color> leftDoorColor = Colors.green as ValueNotifier<Color>;
Color leftDoorColor = Colors.green;
Color rightDoorColor = Colors.green;
Color alarmColor = Colors.green;
var pubTopic = 'Remote';
var pongCount = 0;
String receivedColor = "GREEN";
Color gotColor = Colors.green;

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
  print('Connecting to garage topic');
  const topic = 'garage';
  client.subscribe(topic, MqttQos.atMostOnce);
  client.subscribe('garage/leftDoorMagStatus', MqttQos.atMostOnce);
  client.subscribe('garage/rightDoorMagStatus', MqttQos.atMostOnce);
  client.subscribe('garage/alarmStatus', MqttQos.atMostOnce);
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
        'Remote::Published notification:: topic is ${message.variableHeader!.topicName}, content is: ${message.payload.message} with Qos ${message.header!.qos}');
    newColor(message);
    //Assign color from message

    // ValueListenableBuilder(
    //   valueListenable: doorColor,
    //   builder: (BuildContext context, Color value, Widget? child) {
    //     return Container();
    //   },
    // );
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

Color newColor(message) {
  // if (receivedColor == "RED") {
  //   gotColor = Colors.red;
  // } else if (receivedColor == "GREEN") {
  //   gotColor = Colors.green;
  // }

  if (message.variableHeader!.topicName == "garage/leftDoorMagStatus") {
    if (MqttPublishPayload.bytesToStringAsString(message.payload.message) ==
        "1") {
      print("mag switch is on");
      leftDoorColor = Colors.green;
    }
    if (MqttPublishPayload.bytesToStringAsString(message.payload.message) ==
        "0") {
      leftDoorColor = Colors.red;
      print("mag switch is off");
    }

    print("It's leftDoorMagStatus");
  }
  return leftDoorColor;
}

/// Pong callback
void pong() {
  print('Remote::Ping response client callback invoked');
  pongCount++;
}
