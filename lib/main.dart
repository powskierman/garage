// ignore_for_file: avoid_print

import 'package:mqtt_client/mqtt_client.dart';
import 'package:remote/mqtt_ctl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
      // floatingActionButton:NeumorphicFloatingActionButton(
      // child: const Icon(Icons.garage_outlined, size: 190, color: Colors.green),
      // onPressed: (() {
      //   print("onClick");},
      //),
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: AppBar(
        title: Text(appTitle),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NeumorphicButton(
                onPressed: () {
                  print("leftDoor");
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  depth: 20,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(Icons.garage_outlined,
                    size: 190, color: Colors.green),
                // Icon(
                //   Icons.favorite_border,
                //   //color: _iconsColor(context),
                // ),
              ),
              NeumorphicButton(
                onPressed: () {
                  print("rightDoor");
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  depth: 20,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(Icons.garage_outlined,
                    size: 190, color: Colors.green),
                // Icon(
                //   Icons.favorite_border,
                //   //color: _iconsColor(context),
                // ),
              ),
              //Icon(Icons.garage_outlined, size: 190, color: Colors.green),
              // Icon(Icons.garage_outlined, size: 190, color: Colors.green),
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
        builder.addString('ON');
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
        trackColor = Colors.red;
        alarmColor = trackColor;
      });
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Alarme Désactivé';
        builder.addString('OFF');
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
