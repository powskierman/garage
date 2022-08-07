import 'package:flutter/material.dart';

String appTitle = 'Ouvre Porte Garage';
Color trackColor = Colors.green;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              Icon(Icons.garage_outlined, size: 175, color: Colors.green),
              Icon(Icons.garage_outlined, size: 175, color: Colors.green),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.alarm, size: 175, color: Colors.green),
              SwitchScreen(),
            ],
          )
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

  Color toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Alarme       Activé';
        trackColor = Colors.red;
      });
      debugPrint('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Alarme Désactivé';
        trackColor = Colors.green;
      });
      debugPrint('Switch Button is OFF');
    }
    return trackColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Transform.scale(
          scale: 2.5,
          child: Switch(
            onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: Colors.redAccent,
            activeTrackColor: trackColor,
            inactiveThumbColor: Colors.greenAccent,
            inactiveTrackColor: trackColor,
            //dragStartBehavior: DragStartBehavior.start,
          )),
      Text(
        textValue,
        style: const TextStyle(fontSize: 20),
      )
    ]);
  }
}
