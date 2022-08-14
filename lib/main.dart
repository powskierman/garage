// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:garage/mqtt_ctl.dart';

String appTitle = 'Ouvre Porte Garage';
Color trackColor = Colors.green;
Color alarmColor = Colors.green;

void main() {
  connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late MqttClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.garage_outlined, size: 190, color: Colors.green),
              Icon(Icons.garage_outlined, size: 190, color: Colors.green),
            ],
          ),
          const SwitchScreen(),
        ],
      ),
    );
  }
}

class SwitchScreen extends StatefulWidget {
  const SwitchScreen({Key? key}) : super(key: key);

  @override
  SwitchClass createState() => SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  static Color alarmColor = Colors.green;

  Color toggleSwitch(bool value) {
    pubTopic = 'garage/switch';
    builder.clear();
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Alarme       Activé';
        builder.addString('1');
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
        trackColor = Colors.red;
        alarmColor = trackColor;
      });
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Alarme Désactivé';
        builder.addString('0');
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
        trackColor = Colors.green;
        alarmColor = trackColor;
      });
    }
    return trackColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.alarm, size: 250, color: alarmColor),
        Transform.scale(
            scale: 2.5,
            child: Switch(
              onChanged: toggleSwitch,
              value: isSwitched,
              activeColor: Colors.redAccent,
              activeTrackColor: trackColor,
              inactiveThumbColor: Colors.greenAccent,
              inactiveTrackColor: trackColor,
            )),
        Text(
          textValue,
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
