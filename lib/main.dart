// ignore_for_file: avoid_print

import 'package:mqtt_client/mqtt_client.dart';
//import 'package:provider/provider.dart';
import 'package:remote/mqtt_ctl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
//import 'package:remote/value_notifiers.dart';
import 'package:remote/doors.dart';
//import 'package:dcdg/dcdg.dart';

String appTitle = 'Ouvre Porte Garage';
Color trackColor = Colors.green;
Color alarmColor = Colors.green;

void main() => {
      connect(),
      runApp(
        // ChangeNotifierProvider(
        //   create: (_) => PostChanges(),
        //   child:
        const MyApp(),
      ),
      //   ),
    };

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
  String whichDoor = 'leftDoor';

  callback(varDoor) {
    setState(() {
      gotColor;
      whichDoor = varDoor;
      print('At callback.$whichDoor is $gotColor');
    });
  }

  //late MqttClient client;
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Doors(whichDoor: 'leftDoor', callback: callback),
              Doors(whichDoor: 'rightDoor', callback: callback),
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
    pubTopic = 'garage/alarmSwitch';
    builder.clear();
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Alarme       Activé';
        builder.addBool(val: isSwitched);
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
        trackColor = Colors.red;
        alarmColor = trackColor;
      });
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Alarme Désactivé';
        builder.addBool(val: isSwitched);
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
            scale: 2.0,
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
