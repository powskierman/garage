// ignore_for_file: avoid_print

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt_ctl.dart';

class Doors extends StatefulWidget {
  final String whichDoor;
  final Function callback;

  const Doors({super.key, required this.whichDoor, required this.callback});

  @override
  DoorsState createState() => DoorsState();
}

class DoorsState extends State<Doors> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      child: NeumorphicButton(
        onPressed: () {
          pubTopic = 'garage/${widget.whichDoor}';
          builder.clear();
          builder.addString('pressed');
          client.publishMessage(
              pubTopic, MqttQos.exactlyOnce, builder.payload!);
          print("Door button pressed");
        },
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          depth: 10,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Icon(Icons.garage_outlined, size: 150, color: gotColor),
      ),
    );
  }
}

class MagSwitches extends StatefulWidget {
  const MagSwitches({super.key});

  final bool leftDoorMagSwitch = true;
  final bool rightDoorMagSwitch = true;

  @override
  State<MagSwitches> createState() => _MagSwitchesState();
}

class _MagSwitchesState extends State<MagSwitches> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
